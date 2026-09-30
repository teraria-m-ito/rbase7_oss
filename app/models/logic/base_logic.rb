module Logic
  class BaseLogic
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    include ActiveModel::Model

    attr_accessor :issue
    attr_accessor :role

    def initialize(issue = nil)
      self.issue = issue
    end
    
    def update_status(prev_workflow_state, current_workflow_state)
      raise unless prev_workflow_state.present? && current_workflow_state.present?

      return if prev_workflow_state.id == current_workflow_state.id
      
      ::Rails.logger.info("change status #{prev_workflow_state.state_cd}(#{prev_workflow_state.state_name}) -> #{current_workflow_state.state_cd}(#{current_workflow_state.state_name})")

      self.issue.save!

      # RbaseMailer.status_update(self.issue).deliver
    end
    
    def next_state(prev_workflow_state, current_workflow_state, next_status_cd = nil)
      role_id = self.role.nil? ? ::Role.first.id : self.role.id
      if next_status_cd.nil?
        next_state_workflow_state = current_workflow_state.state_flow_workflow_states.joins(:state_flow).where("state_flows.role_id = ?", role_id)
          .avaiable(current_workflow_state.id).first.next_workflow_state
      else
        next_state_workflow_state = current_workflow_state.state_flow_workflow_states.joins(:state_flow).where("state_flows.role_id = ?", role_id)
          .avaiable(current_workflow_state.id).joins(:next_workflow_state).where("workflow_states.state_cd = ?", next_status_cd).first.next_workflow_state
      end
      
      self.issue.prev_workflow_state = current_workflow_state
      self.issue.current_workflow_state = next_state_workflow_state
      
      self.issue.invoke
    end
  end
end