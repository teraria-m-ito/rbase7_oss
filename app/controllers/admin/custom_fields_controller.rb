module Admin
  class CustomFieldsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_sites, only: [:new, :create, :edit, :update, :show]

    before_action :set_custom_field, only: [:show, :edit, :update, :destroy]
    before_action :set_params, only: [:new, :edit]
    before_action :set_issue_type, only: [:new, :create, :edit, :update, :show]
    before_action :restore_custom_field, only: [:show, :edit]

    respond_to :html
    def index
      @custom_fields = CustomField.order(Arel.sql("COALESCE(display_order, 2147483647) ASC"), :id)
      respond_with(@custom_fields)
    end

    desc :auth_as => :index
    def sort
      custom_field_ids = params[:custom_field_ids]
      return head :unprocessable_entity unless custom_field_ids.is_a?(Array)

      CustomField.transaction do
        custom_field_ids.map(&:to_i).each_with_index do |id, idx|
          CustomField.where(id: id).update_all(display_order: idx + 1)
        end
      end

      head :ok
    end

    def show
      respond_with(@custom_field)
    end

    def new
      @custom_field = CustomField.new
      set_available_sites
      respond_with(@custom_field)
    end

    def edit
    end

    def create
      @custom_field = CustomField.new(custom_field_params)
      @custom_field.display_order ||= (CustomField.maximum(:display_order) || 0) + 1
      @custom_field.cleansing
      if @custom_field.save
        flash[:notice] = t("views.common.create_complete_message")
        set_available_sites
        respond_with(@custom_field, location: admin_custom_fields_url)
      else
        render :new, status: :unprocessable_entity
      end

    end

    def update
      @custom_field.assign_attributes(custom_field_params)
      @custom_field.cleansing
      if @custom_field.save
        flash[:notice] = t("views.common.update_complete_message") 
        respond_with(@issue_type, location: admin_custom_fields_url)
      else
        render :edit, status: :unprocessable_entity
      end

    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @custom_field.destroy      
      respond_with(@custom_field, location: admin_custom_fields_url)
    end

    private
    def set_sites
      @sites = current_admin_user.sites.all
    end

    def set_custom_field
      @custom_field = CustomField.find(params[:id])
      set_available_sites
    end
    
    def set_issue_type
      @issue_types = IssueType.user_prohabbits(current_admin_user).all      
    end

    def restore_custom_field
      @custom_field.restore_fields
    end

    def custom_field_params
      params.require(:custom_field).permit! #(:issue_type_name, :issue_type_class)
    end

    def set_params
      @stimulus_params = {
        custom_field_type_id: CustomField.custom_field_type_id_by_key(:issue),
        field_type_enum: CustomField.field_type_enum.map{|x| {id: x.id, regexp: x[:regexp], default_field: x[:default_field], list_field: x[:list_field], calendar: x[:calendar], dt_calendar: x[:dt_calendar]}}
      }.to_json
    end
  end
end
