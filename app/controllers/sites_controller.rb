class SitesController < UserApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  respond_to :html
  def index
    if current_admin_user
      @sites = current_admin_user.sites.active.all
    end
    
    if params[:sites_search_conditions]
      @site_list_counter_index = params[:sites_search_conditions].to_i
      session[:sites_search_conditions] = @site_list_counter_index
      render partial: "show_sites"
    else
      if session[:sites_search_conditions]
        @site_list_counter_index = session[:sites_search_conditions]
      else
        @site_list_counter_index = 3
      end
      respond_with(@sites)
    end
  end
end
