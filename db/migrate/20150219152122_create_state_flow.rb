class CreateStateFlow < ActiveRecord::Migration[6.0]
  def change
    create_table :state_flows do |t|
      t.integer :workflow_id, index: true
      t.integer :role_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
