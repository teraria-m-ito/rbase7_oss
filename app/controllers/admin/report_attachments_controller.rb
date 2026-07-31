module Admin
  class ReportAttachmentsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    protect_from_forgery except: [:create, :destroy]
    
    before_action :set_sites, only: [:create]
    before_action :set_report, only: [:destroy]

    respond_to :html

    def create
      @report = Report.new(report_params)
      report_attachments = @report.report_attachments[0]
      report_attachments.token = @report.uuid
      report_attachments.filename = report_attachments.document.filename
      report_attachments.file_size =report_attachments.document.size
      report_attachments.save! 
      render json: {files: [report_attachments.to_jq_upload]}, status: :created, location: [:admin, @report]
    end

    def destroy
      @report_attachment = ReportAttachment.find(params[:id])
      @report_attachment.destroy
      respond_with(@report, location: edit_admin_report_path(@report))
    end

    private

    def set_report
      @report = Report.find(params[:report_id])
      set_available_sites
    end
    
    def report_params
      params.require(:report).permit!
    end
  end
end
