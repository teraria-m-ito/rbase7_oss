module Admin
  class SystemSettingAttachmentsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_sites, only: [:create]
    before_action :set_system_setting, only: [:destroy]

    respond_to :html

    def create
      @system_setting = SystemSetting.new(system_setting_params)

      ActiveRecord::Base.transaction do
        @system_setting.system_setting_attachments.each do |system_setting_attachment|
          system_setting_attachment.save_attachment(@system_setting.uuid)
        end
      end

      render json: {}, status: :created
    end

    def destroy
      @system_setting_attachment = SystemSettingAttachment.find(params[:id])
      @system_setting_attachment.destroy
      respond_with(@system_setting, location: edit_admin_system_setting_path(@system_setting))
    end

    private

    def set_system_setting
      @system_setting = SystemSetting.find(params[:system_setting_id])
      set_available_sites
    end
    
    def system_setting_params
      params.require(:system_setting).permit!
    end
  end
end
