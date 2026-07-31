class StateFlow < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  has_many :state_flow_workflow_states, inverse_of: :state_flow
  has_many :current_workflow_states, :through => :state_flow_workflow_states, foreign_key: :id, primary_key: :current_workflow_state_id
  has_many :next_workflow_states, :through => :state_flow_workflow_states, foreign_key: :id, primary_key: :next_workflow_state_id

  belongs_to :role, optional: true
  belongs_to :workflow, optional: true
  
  accepts_nested_attributes_for :state_flow_workflow_states,  :allow_destroy => true

  validates :role_id, presence: true,
    uniqueness: {
      message: I18n.t(:role_id),
      scope: [:workflow_id]
    }

  validates :workflow_id, presence: true
  
end
