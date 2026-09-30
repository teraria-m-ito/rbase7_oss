module Admin
  class WorkflowStatesController < AdminApplicationController
    protect_from_forgery except: [:move_up, :move_down]
    
    before_action :set_workflow
    before_action :set_workflow_state, only: [:show, :edit, :update, :destroy, :move_up, :move_down]

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

      redirect_to edit_admin_workflow_path(@workflow)
    end

    # desc :auth_as => :other, :display_name => 'admin/workflow_states_move_up'
    desc :auth_as => :edit
    def move_up
      display_order = @workflow_state.display_order
      prev_workflow_state = WorkflowState.where("workflow_id = ? and display_order = ?", @workflow_state.workflow_id , @workflow_state.display_order - 1).first
      
      WorkflowState.transaction do
        prev_workflow_state.update!({display_order: display_order})
        @workflow_state.update!({display_order: display_order - 1})
      end
      @workflow_states = @workflow_state.workflow.workflow_states.order(:display_order)
      render turbo_stream: turbo_stream.replace('entry-state-forms', partial: 'admin/workflows/form_workflow_states'), status: :see_other
    end

    #    desc :auth_as => :other, :display_name => 'admin/workflow_states_move_down'
    desc :auth_as => :edit
    def move_down
      display_order = @workflow_state.display_order
      prev_workflow_state = WorkflowState.where("workflow_id = ? and display_order = ?", @workflow_state.workflow_id, @workflow_state.display_order + 1).first
      
      WorkflowState.transaction do
        prev_workflow_state.update!({display_order: display_order})
        @workflow_state.update!({display_order: display_order + 1})
      end
      @workflow_states = @workflow_state.workflow.workflow_states.order(:display_order)
      render turbo_stream: turbo_stream.replace('entry-state-forms', partial: 'admin/workflows/form_workflow_states'), status: :see_other
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
