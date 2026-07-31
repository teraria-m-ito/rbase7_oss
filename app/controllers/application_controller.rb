# coding: utf-8
class ApplicationController < ActionController::Base
  include ::Prestruct
  include ::ControllerCommon

  # Accept-Language に基づき I18n ロケールを切り替える（日本語を優先しない場合は英語）
  around_action :with_locale_from_accept_language  if Rails.env.production?

  before_action :check_flash
  before_action :restore_turbo_redirect_flash
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  #flashが消える現象があり、読み込むことで回避する
  def check_flash
       flash
  end

  # Turbo が 303 を追ったあと通常の flash が描画されないことがあるため、
  # CanCan 等で退避したメッセージを次リクエストの flash に戻す。
  def restore_turbo_redirect_flash
    msg = session.delete(:_rbase_turbo_flash_alert)
    return if msg.blank?

    flash[:alert] ||= msg
  end
  public

  before_action :set_current_page
  before_action :set_menu_collapse

  #before_action :check_permission
  before_action :reset_session

  #パラメータが抜ける不具合が発生。一旦コメントアウト
  before_action :current_ability
  before_action :check_permission
  before_action :set_stamper
  before_action :sso_logout_link
  # before_action :check_sign_in

  after_action :flash_turbo_settings

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery prepend: true
  
  include DeviseHelper
  
  before_action :set_request_filter

  before_action :keep_flash_if_turbo_frame_request

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
    # rescue_from Rack::Timeout::RequestTimeoutException, with: :_render_500
  end

  private
  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def set_request_filter
    Thread.current[:request] = request
  end

  public
  
  ACTION_TO_CATEGORY_NAME = {
    'index'          => 'index',
    'list'           => 'index',
    'show'           => 'show' ,
    'new'            => 'create',
    'create'         => 'create',
    'create_confirm' => 'create',
    'confirm_create' => 'create',
    'edit'           => 'update',
    'update'         => 'update',
    'update_confirm' => 'update',
    'confirm_update' => 'update',
    'destroy'        => 'destroy',
  }

  BASE_ACTION_DISPLAY_NAME_SUFFIXES = {
    'index'          => '_index',
    'list'           => '_index',
    'show'           => '_show',
    'new'            => '_create',
    'create_confirm' => '_create_confirm',
    'create'         => '_create',
    'edit'           => '_update',
    'update_confirm' => '_update_confirm',
    'update'         => '_update',
    'destroy'        => '_destroy',
  }
  
  
  rescue_from CanCan::AccessDenied do |exception|
    referer = begin
      request.referer.present? ? Rails.application.routes.recognize_path(request.referer) : {}
    rescue ActionController::RoutingError
      {}
    end
    ::Rails.logger.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    ::Rails.logger.info("CanCan::AccessDenied")
    ::Rails.logger.info("role: #{current_admin_user.try(:role).try(:role_short_name)}")
    ::Rails.logger.info("request: #{request.url}")
    ::Rails.logger.info("referer controlle: (#{referer[:controller]}) action: (#{referer[:action]})")
    ::Rails.logger.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    flash[:alert] = exception.message
    session[:_rbase_turbo_flash_alert] = exception.message

    # move_up 等は成功時が turbo_stream.replace のため、権限エラーも Turbo Stream でメッセージを返す
    # （303 HTML リダイレクトでは Turbo が最終 200 のみ見て flash / X-Flash が届かない）
    if access_denied_reply_with_turbo_stream?
      render turbo_stream: turbo_stream.replace(
        "entry-common-message",
        partial: "common/entry_common_message"
      ), status: :forbidden
    else
      if referer[:controller].present?
        begin
          redirect_to referer, status: :see_other
          #      redirect_to controller: referer[:controller], action: referer[:action], status: :see_other
        rescue
          exception_redirect
        end
      else
        exception_redirect
      end
      assign_x_flash_messages_header
    end
  end

  private

  def with_locale_from_accept_language
    I18n.with_locale(resolve_locale_from_accept_language) { yield }
  rescue => e
    root_frame = Array(e.backtrace).find { |line| !line.include?("with_locale_from_accept_language") } || Array(e.backtrace).first
    Rails.logger.error("[with_locale_from_accept_language] #{e.class}: #{e.message}")
    Rails.logger.error("[with_locale_from_accept_language] root=#{root_frame}") if root_frame
    raise
  end

  # RFC 7231 の Accept-Language を解釈し、先頭の ja / en に一致するロケールを返す。
  # 日本語は :ja、英語訳系は :en。いずれにも合致しない言語のみの場合は :en。
  # ヘッダが空の場合は config.i18n.default_locale（:ja）のまま。
  def resolve_locale_from_accept_language
    header = request.env["HTTP_ACCEPT_LANGUAGE"].to_s
    return I18n.default_locale if header.strip.empty?

    entries = []
    header.split(",").each_with_index do |part, index|
      part = part.strip
      next if part.empty?

      lang_range, *params = part.split(";").map(&:strip)
      q = 1.0
      params.each do |p|
        q = Regexp.last_match(1).to_f if p.match(/\Aq=([\d.]+)\z/i)
      end
      entries << { tag: lang_range.downcase, q: q, idx: index }
    end
    return I18n.default_locale if entries.empty?

    sorted = entries.sort_by { |e| [-e[:q], e[:idx]] }
    sorted.each do |e|
      primary = e[:tag].split("-", 2).first
      return :ja if primary == "ja"
      return :en if primary == "en"
    end

    :en
  end

  def access_denied_reply_with_turbo_stream?
    return true if request.format.turbo_stream?

    accept = request.headers["Accept"].to_s
    return true if accept.include?("text/vnd.turbo-stream.html")

    # workflow_states の move_up / move_down（HTML Accept でも成功レスポンスは turbo_stream）
    request.path.match?(%r{/admin/workflows/\d+/workflow_states/\d+/move_(up|down)\z})
  end

  def exception_redirect
    redirect_to root_path
  end

  protected
  def set_principal(instance)
    instance.current_admin_user = current_admin_user
    instance.current_site_id = current_site_id
  end

  def check_permission
    raise CanCan::AccessDenied unless can? :manage, :all
    return true
  end

  def current_ability
    force = request.path.start_with?("/uploads") || request.path.start_with?("/docs") || request.path.start_with?("/api")  || request.path.start_with?("/admin_users/sign_in")
    @current_ability = Ability.new(current_admin_user, request[:controller], request[:action], force)
    @current_ability
  end

  def current_site_id
    session[:active_site_id]
  end

  def reset_session
    if params[:clear] == 'true'
      session[:"#{controller_name}_condition"] = nil
      session[:"#{controller_name}_search_conditions"] = nil
      session[:"#{controller_name.singularize}"] = nil
    end
  end
  # 
  # classの定義が完了した後にdescが書かれていないアクションに対して
  # 自動でdescを補完するために設定を追加しています。
  # descが書かれていないアクションのうち、標準的なものに関しては自動でdescを補完しています。
  # 
  private
  def self.prepare_action_descriptions
    return if @prepared_action_descriptions
    controller_desc = Prestruct.find_or_new_module(self)
    controller_desc.update(:controller_path => self.controller_path) if controller_desc[:controller_path].nil?
    if controller_desc[:display_name].blank?
      controller_desc.update(:display_name => self.controller_path)
    end
    controller_display_base = controller_desc[:display_name].sub(/管理$/, '')
    actions = self.action_methods
    actions.each do |action|
      action_desc = controller_desc.find_or_new_method(action.to_s)
      category_name = action_desc[:category_name]
      if category_name.blank?
        if category_name = ACTION_TO_CATEGORY_NAME[action.to_s]
          action_desc.update(:category_name => category_name)
        end
      end
      display_name = action_desc[:display_name]
      if display_name.blank?
        if display_name_suffix = BASE_ACTION_DISPLAY_NAME_SUFFIXES[action.to_s]
          action_desc.update(:display_name => "#{controller_display_base}#{display_name_suffix.to_s}")
        end
      end
      auth_as = action_desc[:auth_as]
      if auth_as.blank?
        if auth_as = ACTION_TO_CATEGORY_NAME[action.to_s]
          if self.action_methods.include?(auth_as)
            unless auth_as == action.to_s
              action_desc.update(:auth_as => auth_as.to_s)
            end
          end
        end
      end
    end
    @prepared_action_descriptions = true
  end

  def set_current_page
    @active_menu = "/#{params[:controller]}" 
    session[:current_page] = {controller: @active_menu}
    session[:current_url] = request.fullpath

    # 遷移元を保存
    unless request.referer.blank?
      uri = URI.parse(request.referer)
      session[:request_referer] = uri.path
    else
      session[:request_referer] = nil
    end
  end
  
  def set_menu_collapse
    @sidebar_admin_opened = ""
    @sidebar_opened = "menu-open"
  end  

  def redirect_root
    site = ::Site.first
    unexpected_url = [new_admin_user_session_path]
    unexpected_url = unexpected_url + extend_unexpected_url.to_a
    unless SystemSetting.get_setting(:force_sign_in, site.id) == "1"
      unexpected_url << root_path
    end

    unless unexpected_url.include?(Thread.current[:request].path)
      unless admin_user_signed_in?
        if SystemSetting.get_setting(:sso_enable, site.id) == "1" and SystemSetting.get_setting(:force_sso_login, site.id) == "1"
          sso_type = ::SystemSetting.get_setting(:sso_type, site.id)
          case sso_type
          when "saml2" then
            session[:direct_url] = Thread.current[:request].fullpath
            request = OneLogin::RubySaml::Authrequest.new
            redirect_to(request.create(saml_settings), allow_other_host: true)
          end
        else
          uri = URI.parse(Thread.current[:request].url)
          session[:direct_url] = Thread.current[:request].url if root_path != uri.path
          redirect_to new_admin_user_session_path
        end
      else
        if session[:direct_url]
          url = session[:direct_url].dup
          session[:direct_url] = nil
          redirect_to url
        end
      end
    end
  end

  #許可URLの拡張ポイント
  def extend_unexpected_url;end

  def keep_flash_if_turbo_frame_request
    # flash.keep if turbo_frame_request?
  end

  def _render_403(e = nil)
    ::Rails.logger.info "Rendering 403 with excaption: #{e.message}" if e

    render "errors/403", status: :not_found, layout: "error"
  end
  def _render_404(e = nil)
    ::Rails.logger.info "Rendering 404 with excaption: #{e.message}" if e

    render "errors/404", status: :not_found, layout: "error"
  end

  def _render_500(e = nil)
    ::Rails.logger.error "Rendering 500 with excaption: #{e.message}" if e
    ::Rails.logger.error e.backtrace.join("\n") if e
    render "errors/500", status: :internal_server_error, layout: "error"
  end

  def set_stamper
    current_admin_user.stamper = current_admin_user if current_admin_user
  end

  def sso_logout_link
    if current_admin_user and current_admin_user.login_from.present?
      if session[:sso_url]
        @sso_url = session[:sso_url]
        @sso_params = session[:sso_params]
      else
        site_id = current_site_id ? current_site_id : Site.first.id
        sso_type = ::SystemSetting.get_setting(:sso_type, site_id)
        @sso_url = nil
        case sso_type
        when "saml2" then
          logic = eval("::Logic::Sso#{sso_type.classify}Logic.new")
          if logic
            settings = logic.settings
            logout_request = OneLogin::RubySaml::Logoutrequest.new
            slo_url = logout_request.create(settings, name_id: current_admin_user.email, sessionindex: current_admin_user.sso_session_id)
            uri = URI.parse(slo_url)
            @sso_url = session[:sso_url] = "#{uri.scheme}://#{uri.host}#{uri.path}"
            @sso_params = session[:sso_params] = URI.decode_www_form(uri.query).to_h
          end
        end
      end
    end
  end

  # def check_sign_in
  #   unless is_current_page?("/admin_users/sign_in")
  #     site = Site.first
  #     if ::SystemSetting.get_setting(:force_sign_in, site.id)
  #     unless current_admin_user
  #       redirect_to new_admin_user_session_path
  #     end
  #     end
  #   end
  # end

  def flash_turbo_settings
    if response.content_type.to_s.include?("text/vnd.turbo-stream.html; charset=utf-8")
      flash_to_headers
    elsif response.status.to_i.between?(300, 399) && flash.any?
      # Turbo が 303 を追う前のレスポンスで flash を読めないことがあるため、リダイレクト時もヘッダに載せる
      assign_x_flash_messages_header
    end
  end

  # X-Flash-Messages のみ付与（flash.discard しない）。セッション経由の flash も維持する。
  def assign_x_flash_messages_header
    return if flash.to_hash.blank?

    response.headers["X-Flash-Messages"] = flash_json
  end

  def flash_to_headers
    response.headers['X-Flash-Messages'] = flash_json
    flash.discard
  end
  def flash_json
    flash.inject({}) do |hash, (type, message)|
      result = []
      if message.is_a?(Array)
        message.each do |m|
          result << "#{URI.encode_www_form_component(ERB::Util.html_escape(m))}"
        end
        message = result
      else
        message = "#{ERB::Util.html_escape(message)}"
        message = URI.encode_www_form_component(message)
      end

      hash[type] = message
      hash
    end.to_json
  end

  def saml_settings
    site = Site.first
    sso_type = ::SystemSetting.get_setting(:sso_type, site.id)

    logic = eval("::Logic::Sso#{sso_type.classify}Logic.new")
    logic.settings
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:current_site_id, :name, :email])
  end

  public
  include Rbase::PluginModule::Includable
end

# 各コントローラが定義され終わった直後にdescの補完を実行できるように、
# unless ActiveSupport::Dependencies.respond_to?(:load_missing_constant_with_rbase_omission)
# 
  # ActiveSupport::Dependencies.instance_eval do
    # def load_missing_constant_with_rbase_omission(from_mod, const_name, &block)
      # result = load_missing_constant_without_rbase_omission(from_mod, const_name, &block)
      # if result.is_a?(Class) && (result < ApplicationController)
        # result.prepare_action_descriptions
      # end
      # result
    # end
# 
    # self.instance_eval do
      # alias :load_missing_constant_without_rbase_omission :load_missing_constant
      # alias :load_missing_constant :load_missing_constant_with_rbase_omission
    # end
  # end
# end

