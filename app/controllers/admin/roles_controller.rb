module Admin
  class RolesController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_role, only: [:show, :edit, :update, :destroy, :copy]
    before_action :set_role_action, only: [:show, :new, :edit]

    respond_to :html
    def index
      @roles = Role.all.page(params[:page])
      respond_with(@roles)
    end

    def show
      respond_with(@role)
    end

    def new
      @role = Role.new
      @role.role_role_actions.build
      respond_with(@role)
    end

    def edit
    end

    def create
      @role = Role.new(role_params)
      if @role.valid?
        @role.save!
        flash[:notice] = t("views.common.create_complete_message")
        respond_with(@role, location: admin_roles_url)
      else
        set_role_action
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @role.assign_attributes(role_params)
      if @role.valid?
        @role.save!
        flash[:notice] = t("views.common.update_complete_message")
        respond_with(@role, location: admin_roles_url)
      else
        set_role_action
        render :edit, status: :unprocessable_entity
      end
    end

    desc :auth_as => :new
    def copy
      if @role.copy
        flash[:notice] = t("views.common.copy_complete_message")
        redirect_to admin_roles_path, status: :see_other
      else
        flash[:alert] = t("views.common.copy_error_message")
        @roles = Role.all.page(params[:page])
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @role.destroy
      respond_with(@role, location: admin_roles_url)
    end

    private

    def set_role
      @role = Role.find(params[:id])
    end
    
    def set_role_action
      @controller_names = RoleAction.ordered.pluck(:controller_name).uniq
      @actions = {}
      @controller_names.each do |controller_name|
        role_action = RoleAction.where(controller_name: controller_name)
        @actions[controller_name.to_sym] = {
          auth_as_index: role_action.auth_as_index.post_path.all,
          auth_as_show: role_action.auth_as_show.post_path.all,
          auth_as_create: role_action.auth_as_create.post_path.all,
          auth_as_update: role_action.auth_as_update.post_path.all,
          auth_as_destroy: role_action.auth_as_destory.post_path.all,
          auth_as_others: role_action.auth_as_others.all
         }
      end
    end

    def role_params
      params.require(:role).permit!#(:role_name, role_role_actions_attributes: [:role_id, :role_action_id, :id])
    end
  end
end
