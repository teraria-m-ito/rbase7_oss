class CreateWorkflow < ActiveRecord::Migration[6.0]
  def change
    create_table :workflows do |t|
      t.string :workflow_name
      t.integer :issue_type_id, index: true
      t.boolean :deletable
      t.datetime :deleted_at, index: true
      
      t.timestamps
    end
  end
end
