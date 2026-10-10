class AdminUsers::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  before_action :configure_permitted_parameters
  before_action :setup_values
  before_action :set_unique_key, only: [:edit]
  before_action :set_admin_user_custom_fields, only: [:edit]

  # GET /resource/sign_up
  def new
   build_resource({})
   resource.admin_user_sites.build
   respond_with self.resource
  end

  # POST /resource
  #def create
  #   super
  #end

  # GET /resource/edit
  def edit
    self.resource.uuid = @uuid
  end

  # PUT /resource
  def update
    uuid = params.dig(:admin_user, :uuid)
    # 本人情報の更新と添付ファイルの紐付けを同一トランザクションで行い、どちらかが失敗したらまとめて戻す
    ActiveRecord::Base.transaction do
      super do |updated_resource|
        updated_resource.uuid = uuid
        next if uuid.blank? || updated_resource.errors.any?

        AdminUserAttachment.where(token: uuid).each do |attach|
          attach.admin_user = updated_resource
          attach.save!
        end
      end
    end
    flash[:notice] = t("views.common.update_complete_message") if response.redirect?
  rescue => e
    logger.error("[AdminUsers::RegistrationsController#update] #{e.class}: #{e.message}\n#{e.backtrace&.join("\n")}")
    raise if performed?

    set_admin_user_custom_fields
    flash.now[:alert] = t("views.common.error_message")
    render :edit, status: :unprocessable_entity
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private
  def setup_values
    @sites = Site.active.all
  end

  def user_params
    params.require(:admin_user).permit!
  end

  def set_unique_key
    @uuid = AdminUser.set_unique_key
  end

  def set_admin_user_custom_fields
    @custom_fields = CustomField.admin_users
    site_ids = self.resource.site_ids.presence || [current_site_id].compact
    @custom_fields = @custom_fields.for_site(site_ids) if site_ids.present?
    @custom_fields.each do |custom_field|
      self.resource.admin_user_custom_fields << AdminUserCustomField.new(custom_field_id: custom_field.id) unless self.resource.admin_user_custom_fields.map(&:custom_field_id).include?(custom_field.id)
    end
  end

  public
  
  protected
  def configure_permitted_parameters
    # role_id / site_ids は本人に変更させない（権限昇格防止）。管理者が管理画面から設定する。
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, {:admin_user_custom_fields_attributes => [:id, :field_value]}])
  end

  def update_resource(resource, params)
    super
  end

  public
end
