class TopController < UserApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  before_action :set_system_setting

  respond_to :html
  def index
    if current_admin_user
      active_sites = current_admin_user.sites.active
      if active_sites.size == 1
        flash[:stimulus_params] = @stimulus_params
        return redirect_to top_path(active_sites.first)
      end
      @sites = active_sites.page(params[:page])
      respond_with(@sites)
    end
  end

  def show
    @stimulus_params = flash[:stimulus_params] if flash[:stimulus_params]
    site_id = accepted_site_id(params[:id])
    if site_id && current_admin_user.site_ids.map(&:to_i).include?(site_id)
      current_admin_user.selected_site = site_id
    end
  end
  
  private
  def set_system_setting
    site_id = request_site_id
    site_id = accepted_site_id(params[:id]) || site_id if action_name == "show"
    @system_setting = nil
    return if site_id.blank?

    @system_setting = SystemSetting.joins(:system_setting_sites).where(setting_div: SystemSetting.setting_div_id_by_key(:available_register_user)).where("system_setting_sites.site_id = ?", site_id).first
  end

  def redirect_root
    super
  end
end
