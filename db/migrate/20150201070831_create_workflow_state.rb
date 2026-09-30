class CreateWorkflowState < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_states do |t|
      t.integer :workflow_id
      t.string :state_cd
      t.string :state_name
      t.boolean :default_value
      t.boolean :end_point
      t.integer :display_order
      t.boolean :deleted_state
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
