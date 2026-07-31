module StateFlows
  class SearchConditions
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
    include ActiveModel::Model
    attr_accessor :role_id, :workflow_id

    validates :role_id, presence: {message: I18n.t("activerecord.errors.messages.blank")}
    validates :workflow_id, presence: {message: I18n.t("activerecord.errors.messages.blank")}
    
    def search
      state_flow = StateFlow.where(role_id: self.role_id).where(workflow_id: self.workflow_id).first
      return state_flow || StateFlow.new({role_id: self.role_id, workflow_id: self.workflow_id}), Workflow.find(self.workflow_id)
    end
  end
    
end