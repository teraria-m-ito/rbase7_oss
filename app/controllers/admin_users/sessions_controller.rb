class AdminUsers::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  attr_accessor :login_id_type

  before_action :set_site, only: [:new, :create]
  # GET /resource/sign_in
  def new
    super
    @site = params[:site].presence
  end

  # POST /resource/sign_in
  def create
    super
    return unless current_admin_user

    current_admin_user.login_from = nil
    current_admin_user.save!
    current_admin_user.selected_site = current_admin_user.current_site_id
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
  protected
  def after_sign_in_path_for(resource)
    if session[:direct_url].present?
      url = session[:direct_url]
      session.delete(:direct_url)
      url
    else
      site = current_admin_user.sites.first
      top_path(site)
    end
  end

  private
  def set_site
    @site = params[:site].presence
  end
end
