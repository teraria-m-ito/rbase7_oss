module Admin
  class SitesController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    load_and_authorize_resource
#    class_desc :display_name => 'サイト管理'
    
    before_action :set_site, only: [:show, :edit, :update, :destroy]

    respond_to :html
    def index
      @sites = Site.all.page(params[:page])
      respond_with(@sites)
    end

    def show
      respond_with(@site)
    end

    def new
      @site = Site.new
      respond_with(@site)
    end

    def edit
    end

    def create
      @site = Site.new(site_params)
      if @site.save
        flash[:notice] = t("views.common.create_complete_message")
        respond_with(@site, location: admin_sites_url)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @site.update(site_params)
        flash[:notice] = t("views.common.update_complete_message")
        respond_with(@site, location: admin_sites_url)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @site.destroy
      respond_with(@site, location: admin_sites_url)
    end

    private
    def set_site
      @site = Site.find(params[:id])
    end

    def site_params
      params.require(:site).permit(:site_name, :status_div)
    end
    public
  end
end