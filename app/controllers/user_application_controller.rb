# coding: utf-8
class UserApplicationController < ApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  before_action :redirect_root

  private
  def get_current_site_id
    Thread.current[:request].session[:active_site_id]
  end

  def set_sort_field
    prepare_sort_session
    toggle_sort_direction(@sort_field_name)
    normalize_sort_orders
    session[@model_name]
  end

  def set_sort_single_field
    model_session_was_blank = session[@model_name].nil?
    prepare_sort_session

    if session[:prev_sort_field_name] != @sort_field_name
      session[@model_name][session[:prev_sort_field_name]] = {}
    end

    toggle_sort_direction(@sort_field_name)
    normalize_sort_orders
    session.delete(:prev_sort_field_name) if model_session_was_blank
    session[:prev_sort_field_name] = @sort_field_name
    session[@model_name]
  end

  def prepare_sort_session
    session[@model_name] = {} if session[@model_name].nil?
    session[@model_name][@sort_field_name] = {} if session[@model_name][@sort_field_name].nil?
  end

  def next_sort_order
    (session[@model_name].map { |k, _v| session[@model_name][k][:order].to_i }.max || 0) + 1
  end

  def toggle_sort_direction(field_name)
    count = next_sort_order
    session[@model_name][field_name] = {} if session[@model_name][field_name].nil?
    case session[@model_name][field_name][:direction]
    when nil
      session[@model_name][field_name][:direction] = :asc
      session[@model_name][field_name][:order] = count
    when :asc
      session[@model_name][field_name][:direction] = :desc
      session[@model_name][field_name][:order] = count
    else
      session[@model_name][field_name][:direction] = nil
      session[@model_name][field_name][:order] = nil
    end
  end

  def normalize_sort_orders
    session[@model_name] = session[@model_name]
      .sort_by { |k, _v| session[@model_name][k][:order].to_i }
      .select { |x| x[1][:direction].present? }
      .to_h
    count = 1
    session[@model_name].each do |k, _v|
      session[@model_name][k][:order] = count
      count += 1
    end
  end
end

