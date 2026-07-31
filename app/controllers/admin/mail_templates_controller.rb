module Admin
  class MailTemplatesController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_mail_template, only: [:show, :edit, :update, :destroy]

    respond_to :html
    def index
      @mail_templates = MailTemplate.all.page(params[:page])
      respond_with(@mail_templates)
    end

    def show
      respond_with(@mail_template)
    end

    def new
      @mail_template = MailTemplate.new
      set_available_sites
      respond_with(@mail_template)
    end

    def edit
    end

    def create
      @mail_template = MailTemplate.new(mail_template_params)
      if @mail_template.save
        flash[:notice] = t("views.common.create_complete_message") 
        respond_with(@mail_template, location: admin_mail_templates_url)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @mail_template.update(mail_template_params)
        flash[:notice] = t("views.common.update_complete_message") 
        respond_with(@mail_template, location: admin_mail_templates_url)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @mail_template.destroy      
      respond_with(@mail_template, location: admin_mail_templates_url)
    end

    private

    def set_mail_template
      @mail_template = MailTemplate.find(params[:id])
      set_available_sites
    end

    def mail_template_params
      params.require(:mail_template).permit!
    end
  end
end
