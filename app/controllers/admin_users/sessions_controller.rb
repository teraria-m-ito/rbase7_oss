class AdminUsers::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  attr_accessor :login_id_type

  before_action :set_site, only: [:new, :create]
  # GET /resource/sign_in
  def new
    super
    @site = request_site_param
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
      site_id = request_site_id
      site_id = accepted_site_id(current_admin_user.try(:current_site_id)) if site_id.blank?
      site_id = accepted_site_id(current_admin_user.try(:selected_site)) if site_id.blank?
      if site_id.blank?
        allowed = current_admin_user.sites.active
        site_id = allowed.first.id if allowed.size == 1
      end
      site_id.present? ? top_path(site_id) : root_path
    end
  end

  private
  def set_site
    @site = request_site_param
  end
end
