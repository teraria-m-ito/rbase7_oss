module Admin
  class WorkflowsController < AdminApplicationController
    before_action :set_workflow, only: [:show, :edit, :update, :destroy, :change_sites]
    before_action :set_available_sites

    respond_to :html
    def index
      @workflows = Workflow.all.page(params[:page])
      respond_with(@workflows)
    end

    def show
      respond_with(@workflow)
    end

    def new
      @workflow = Workflow.new
      @workflow.workflow_sites.build
      @workflow.workflow_states.build
      @workflow.site_ids = current_admin_user.sites.map(&:id)

      @stimulus_params = {
        url1: change_sites_admin_workflows_path,
        workflow_id: @workflow.id
      }.to_json

      respond_with(@workflow)
    end

    def edit
      @stimulus_params = {
        url1: change_sites_admin_workflows_path,
        workflow_id: @workflow.id
      }.to_json
    end

    def create
      @workflow = Workflow.new(workflow_params)
      if @workflow.save
        flash[:notice] = t("views.common.create_complete_message")
        redirect_to edit_admin_workflow_path(@workflow)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @workflow.update(workflow_params)
        flash[:notice] = t("views.common.update_complete_message")
        @workflow.site_ids = @workflow.site_ids
        respond_with(@workflow, location: admin_workflows_url)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      flash[:notice] = t("views.common.destroy_complete_message") if @workflow.destroy
      respond_with(@workflow, location: admin_workflows_url)
    end

    desc :auth_as => :edit
    def change_sites
      site_ids = params[:site_ids].blank? ? [] : params[:site_ids].split(',')
      @workflow.site_ids = site_ids
      render turbo_stream: turbo_stream.replace('entry-forms', partial: 'form_issue_type')
    end
    private

    def set_workflow
      @workflow = params[:id].blank? ? Workflow.new : Workflow.find(params[:id])
      @workflow.workflow_states.build unless @workflow.workflow_states
      @workflow_states = @workflow.workflow_states.order(:display_order)
    end

    def workflow_params
      params.require(:workflow).permit!
    end
  end
end
