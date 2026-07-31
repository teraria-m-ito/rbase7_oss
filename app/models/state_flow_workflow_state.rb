class StateFlowWorkflowState < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  has_one :current_workflow_state, class_name: "WorkflowState", foreign_key: :id, primary_key: :current_workflow_state_id
  has_one :next_workflow_state, class_name: "WorkflowState", foreign_key: :id, primary_key: :next_workflow_state_id
  
  belongs_to :state_flow, optional: true

  validates :state_flow, presence: true
#  validates :state_flow_id, presence: true
#  validates :next_workflow_state, presence: true
#  validates :current_workflow_state, presence: true
      
end
