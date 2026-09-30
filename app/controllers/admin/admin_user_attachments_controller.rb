module Admin
  class AdminUserAttachmentsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_sites, only: [:create]
    before_action :set_admin_user, only: [:destroy]

    respond_to :html

    def create
      @admin_user = AdminUser.new(admin_user_params)
      @admin_user.admin_user_attachments[0].token = @admin_user.uuid
      @admin_user.admin_user_attachments[0].filename = @admin_user.admin_user_attachments[0].document.filename
      @admin_user.admin_user_attachments[0].file_size = @admin_user.admin_user_attachments[0].document.size
      @admin_user.admin_user_attachments[0].save! 
      render json: {files: [@admin_user.admin_user_attachments[0].to_jq_upload]}, status: :created #, location: [:admin, @admin_user]
    end

    def destroy
      @admin_user_attachment = AdminUserAttachment.find(params[:id])
      @admin_user_attachment.destroy
      flash[:notice] = t("views.common.destroy_complete_message")

      respond_with(@admin_user, location: edit_admin_user_path(@admin_user))
    end

    private

    def set_admin_user
      @admin_user = AdminUser.find(params[:user_id])
      set_available_sites
    end
    
    def admin_user_params
      new_params = params.require(:admin_user).permit!
      new_params.delete("admin_user_custom_fields_attributes")
      new_params
    end
  end
end
