class AdminApplicationController < ApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  layout 'application'
    
  before_action :redirect_root
    
  private
  def set_menu_collapse
    @sidebar_admin_opened = "menu-open"
    @sidebar_opened = ""
  end  

  def set_sites
    set_available_sites
  end

  def set_available_sites
    @sites = Site.active.where("id IN (?)", current_admin_user.sites.map(&:id)).all.to_a
  end

  public
end
