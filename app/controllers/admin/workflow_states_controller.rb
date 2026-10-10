module Admin
  class WorkflowStatesController < AdminApplicationController
    before_action :set_workflow
    before_action :set_workflow_state, only: [:show, :edit, :update, :destroy]

    respond_to :html

    def show
      respond_with(@workflow_state)
    end

    def new
      @workflow_state = WorkflowState.new
      @workflow_state.workflow_id = params[:workflow_id]
      respond_with(@workflow_state)
    end

    def edit
    end

    def create
      @workflow_state = WorkflowState.new(workflow_state_params)
      @workflow_state.workflow_id = params[:workflow_id]
      @workflow_state.display_order = (WorkflowState.where(workflow_id: @workflow.id).maximum(:display_order) || 0) + 1
      flash[:notice] = t("views.common.update_complete_message") if @workflow_state.save
      respond_with(@workflow_state, location: edit_admin_workflow_path(@workflow))
    end

    def update
      flash[:notice] = t("views.common.update_complete_message") if @workflow_state.update(workflow_state_params)
      respond_with(@workflow_state, location: edit_admin_workflow_path(@workflow))
    end

    def destroy
      if @workflow_state.destroy
        flash[:notice] = t("views.common.destroy_complete_message") 
        @workflow_state.workflow.workflow_states.order(:display_order).each_with_index do |workflow, idx|
          workflow.update({display_order: idx+1})
        end
      end

      redirect_to edit_admin_workflow_path(@workflow), status: :see_other
    end

    # ドラッグで並べ替えた順に表示順を振り直す（対象ワークフローの状態のみ更新する）
    desc :auth_as => :edit
    def sort
      workflow_state_ids = params[:workflow_state_ids]
      return head :unprocessable_entity unless workflow_state_ids.is_a?(Array)

      WorkflowState.transaction do
        workflow_state_ids.map(&:to_i).each_with_index do |id, idx|
          @workflow.workflow_states.where(id: id).update_all(display_order: idx + 1)
        end
      end

      head :ok
    end

    private

    def set_workflow
      @workflow = Workflow.find(params[:workflow_id])
    end
    
    def set_workflow_state
      @workflow_state = WorkflowState.find(params[:id])
      set_available_sites
    end

    def workflow_state_params
      params.require(:workflow_state).permit!
    end
    
  end
end
