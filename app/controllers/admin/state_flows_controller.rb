module Admin
  class StateFlowsController < AdminApplicationController
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    before_action :set_available_sites
    before_action :set_condition_fields
    before_action :set_state_flow, only: [:update]

    respond_to :html
    def index
      if params[:state_flows_search_conditions]
        @condition = StateFlows::SearchConditions.new(search_condition_params)
        return render 'index' unless @condition.valid?
        session[:state_flows_condition] = @condition
        
        @state_flow, @workflow = @condition.search
      else
        if session[:state_flows_condition]
          @condition = session[:state_flows_condition]
          @state_flow, @workflow = @condition.search
        else
          @condition = StateFlows::SearchConditions.new
        end
      end
    end
    
    def new
      
    end
    
    def create
      @state_flow = StateFlow.new(state_flow_params)

      tmp_state_flow_workflow_states = []
      @state_flow.state_flow_workflow_states.each do |state_flow_workflow_state|
        tmp_state_flow_workflow_states << state_flow_workflow_state if (state_flow_workflow_state.next_workflow_state_id.present?)
      end

      @state_flow.state_flow_workflow_states = tmp_state_flow_workflow_states

      if (@state_flow.save)
        flash[:notice] = t("views.common.create_complete_message")
        respond_with(@state_flow, location: admin_state_flows_path)
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
      
    end
    
    def update
      @state_flow.assign_attributes(state_flow_params)
      
      tmp_state_flow_workflow_states = []
      @state_flow.state_flow_workflow_states.each do |state_flow_workflow_state|
        tmp_state_flow_workflow_states << state_flow_workflow_state if (state_flow_workflow_state.next_workflow_state_id.present? || state_flow_workflow_state.id.present?)
      end
      
      @state_flow.state_flow_workflow_states = tmp_state_flow_workflow_states
      
      if (@state_flow.save) 
        flash[:notice] = t("views.common.update_complete_message")
        respond_with(@state_flow, location: admin_state_flows_path(clear: true))
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      
    end
    
    private
    def set_state_flow
      @state_flow = StateFlow.find(params[:id])
    end

    def set_condition_fields
      @workflows = Workflow.user_prohabbits(current_admin_user.site_ids).all
      @roles = Role.all
    end

    def search_condition_params
      params.require(:state_flows_search_conditions).permit!
    end
    def state_flow_params
      params.require(:state_flow).permit!
    end
  end
end
