module Admin
  class UsersController < AdminApplicationController
    before_action :set_new_user, only: [:new]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :set_admin_user_custom_fields, only: [:new, :edit, :show]
    before_action :set_unique_key, only: [:new, :edit]

    respond_to :html
    def index
      if params[:clear] == "true"
        session[:admin_users_search_conditions] = nil
      end

      set_sites

      if params[:admin_users_search_conditions]
        @condition = ::AdminUsers::SearchConditions.new(search_condition_params)
        @condition.site_id = @condition.site_id.reject!(&:empty?)
        return render 'index' unless @condition.valid?
        @condition.current_admin_user = current_admin_user

        session[:admin_users_search_conditions] = @condition
        @users = @condition.search.page(params[:page])
      else
        if session[:admin_users_search_conditions]
          @condition = session[:admin_users_search_conditions]
          @condition.current_admin_user = current_admin_user
          @users = @condition.search.page(params[:page])
        else
          @condition = ::AdminUsers::SearchConditions.new
          @condition.current_admin_user = current_admin_user
          @users = @condition.search.page(params[:page])
          session[:admin_users_search_conditions] = @condition
        end
      end
      render :index
    end

    def show
    end

    def new
      respond_with(@user)
    end

    def edit
      @user.uuid = @uuid
      @sites = Site.active.all.to_a
    end

    def create
      @user = AdminUser.new(user_params)
      set_sites
      set_admin_user_custom_fields
      if @user.save
        flash[:notice] = t("views.common.create_complete_message") 
        respond_with(@user, location: admin_users_url)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      #パスワードがブランクの場合は、変更しない
      if user_params[:password].blank? and user_params[:password_confirmation].blank?
        user_params[:password] = @user.password
        user_params[:password_confirmation] = @user.password
      end
      if @user.update(user_params)
        flash[:notice] = t("views.common.update_complete_message")
        respond_with(@user, location: admin_users_url)
      else
        set_admin_user_custom_fields
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @user.destroy
      respond_with(@user, location: admin_users_url)
    end
    
    private
    def set_new_user
      @user = AdminUser.new
      set_sites
    end
    def set_user
      @user = AdminUser.find(params[:id])
      set_sites
    end
    
    def user_params
      params.require(:admin_user).permit!
    end

    def search_condition_params
      params.require(:admin_users_search_conditions).permit!
    end

    def set_admin_user_custom_fields
      @custom_fields = CustomField.admin_users
      @custom_fields.each do |custom_field|
        @user.admin_user_custom_fields << AdminUserCustomField.new(custom_field_id: custom_field.id) unless @user.admin_user_custom_fields.map(&:custom_field_id).include?(custom_field.id)
      end
    end

    def set_unique_key
      @uuid = Report.set_unique_key
    end

    public
    
  end
end
