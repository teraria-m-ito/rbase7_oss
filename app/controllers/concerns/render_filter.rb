module RenderFilter
  extend ActiveSupport::Concern
 
  included do
    define_callbacks :process_render
  end
 
  public
  def render(*args)
    run_callbacks :process_render do
      super
    end
  end
 
  module ClassMethods
    def before_render(*callbacks, &blk)
      # _insert_callbacks from AbstractController::Callbacks
      # https://github.com/rails/rails/blob/ab8a833e0ba0aa5198fbe3472791e7b58ccbd199/actionpack/lib/abstract_controller/callbacks.rb#L71
      _insert_callbacks(callbacks, blk) do |callback, options|
        set_callback(:process_render, :before, callback, options)
      end
    end
  end
end
 
=begin
How to use

class TestController < ApplicationController
  include RenderFilter
  before_render :func1

  def index
    @str = 'str1'
  end

  private
  def func1
    @str = 'STR2'
  end
end
=end