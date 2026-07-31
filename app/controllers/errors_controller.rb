class ErrorsController < ApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  def routing_error
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end
end