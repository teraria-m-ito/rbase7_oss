class WorkflowState < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  belongs_to :workflow, optional: true
  has_many :state_flow_workflow_states, foreign_key: :current_workflow_state_id do
    def avaiable(current_workflow_state_id)
      where("state_flow_workflow_states.current_workflow_state_id = ?", current_workflow_state_id)
    end
  end

  scope :prohabbits_site, -> site_id {joins(workflow: :workflow_sites).where(workflow_sites: {site_id: site_id}).order("workflow_states.display_order")}
  
  scope :default_point, -> { where("workflow_states.default_value = ?", true).first  }
  scope :end_point, -> { where("workflow_states.end_point = ?", true).first  }
  
  validates :state_cd, presence: true
  validates :state_name, presence: true

  def deletable?
    if self.state_name.include?("作成中")
      return true
    else
      return false
    end
  end

  def prohabbit_state_flow
    self.workflow.state_flows
  end

end
