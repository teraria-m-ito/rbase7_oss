module Admin
  class ReportsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_sites, only: [:create]
    before_action :set_report, only: [:show, :edit, :update, :destroy, :preview]
    before_action :set_unique_key, only: [:new, :edit]
    
    respond_to :html
    def index
      @reports = Report.all.page(params[:page])
      respond_with(@reports)
    end

    def show
      respond_with(@report)
    end

    def new
      @report = Report.new({uuid: @uuid})
      @report.report_attachments.build
      session[:reports_attachments] = nil
      set_available_sites
      respond_with(@report)
    end

    def edit
      @report.uuid = @uuid
    end

    def create
      params[:report][:report_attachments_attributes] = []
      @report = Report.new(report_params)
      @report.report_attachments = @report.report_attachments.select{|x| x.filename.present?}

      ActiveRecord::Base.transaction do
        @report.report_attachments.build unless @report.report_attachments 
        ReportAttachment.where(["token = ?", @report.uuid]).each do |attach|
          @report.report_attachments << attach
        end
        
        if @report.save
          flash[:notice] = t("views.common.create_complete_message")
          respond_with(@report, location: admin_reports_url)
        else
          render :new, status: :unprocessable_entity
        end
      end
      
    end

    def update
      ActiveRecord::Base.transaction do
        @report.assign_attributes(report_params)

        @report.report_attachments = @report.report_attachments.select{|x| x.filename.present?}
        ReportAttachment.where(["token = ?", @report.uuid]).each do |attach|
          @report.report_attachments.build unless @report.report_attachments 
          @report.report_attachments << attach
        end
        
        if @report.save(autosave: false)
          flash[:notice] = t("views.common.update_complete_message")
          respond_with(@report, location: admin_reports_url)
        else
          render :edit, status: :unprocessable_entity
        end
      end

    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @report.destroy
      respond_with(@report, location: admin_reports_url)
    end
    
    desc :auth_as => :index
    def preview
      if params[:target_id].blank?
        @report.set_demo_preview
      else
        @report.set_preview(params[:target_id])
      end
      report_format = @report.invoke
      encoded_filename = ERB::Util.url_encode("#{@report.title}.pdf")
      send_data report_format.generate, filename: encoded_filename, type: 'application/pdf', disposition: 'inline'
    end
    
    private

    def set_report
      @report = Report.find(params[:id])
      set_available_sites
    end
    
    def report_params
      params.require(:report).permit! #(:title, :report_class, :description, :site_ids, :uuid)
    end
    
    def set_unique_key
      @uuid = Report.set_unique_key
    end
  end
end
