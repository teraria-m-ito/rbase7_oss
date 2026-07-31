class TopController < UserApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  before_action :set_system_setting

  respond_to :html
  def index
    if current_admin_user
      if current_admin_user.sites.size == 1
        flash[:stimulus_params] = @stimulus_params
        return redirect_to top_path(current_admin_user.sites.first)
      end
      @sites = current_admin_user.sites.active.all.page(params[:page])
      respond_with(@sites)
    end
  end

  def show
    @stimulus_params = flash[:stimulus_params] if flash[:stimulus_params]
    current_admin_user.selected_site = params[:id].to_i
  end
  
  private
  def set_system_setting
    @system_setting = SystemSetting.joins(:system_setting_sites).where(setting_div: SystemSetting.setting_div_id_by_key(:available_register_user)).where("system_setting_sites.site_id = ?", Site.first.id).first
  end

  def redirect_root
    super
  end
end
