module Admin
  class IssueTypesController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_issue_type, only: [:show, :edit, :update, :destroy]
    before_action :set_available_sites, only: [:new, :create]

    respond_to :html
    def index
      @issue_types = IssueType.all.page(params[:page])
      respond_with(@issue_types)
    end

    def show
      respond_with(@issue_type)
    end

    def new
      @issue_type = IssueType.new
      set_available_sites
      respond_with(@issue_type)
    end

    def edit
    end

    def create
      @issue_type = IssueType.new(issue_type_params)
      if @issue_type.save
        flash[:notice] = t("views.common.create_complete_message")
        redirect_to admin_issue_types_path, status: :see_other
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @issue_type.update(issue_type_params)
        flash[:notice] = t("views.common.update_complete_message")
        redirect_to admin_issue_types_path, status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @issue_type.destroy
      respond_with(@issue_type, location: admin_issue_types_url)
    end

    private

    def set_issue_type
      @issue_type = IssueType.find(params[:id])
      set_available_sites
    end

    def issue_type_params
      params.require(:issue_type).permit! #(:issue_type_name, :issue_type_class)
    end
  end
end
