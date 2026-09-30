class CreateStateFlowWorkflowStates < ActiveRecord::Migration[6.0]
  def change
    create_table :state_flow_workflow_states do |t|
      t.integer :state_flow_id, index: true
      t.integer :current_workflow_state_id, index: true
      t.integer :next_workflow_state_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
