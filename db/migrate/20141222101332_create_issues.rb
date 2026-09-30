class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.integer :site_id, index: true
      t.integer :issue_type_id, index: true
      t.integer :workflow_state_id, index: true
      t.integer :prev_workflow_state_id, index: true
      t.string :priority
      t.string :title
      t.string :expression, limit: 1000
      t.integer :assigned_id
      t.integer :issued_id
      t.datetime :limited_at
      t.datetime :deleted_at, index: true
      t.integer :creator_id
      t.integer :updater_id
      t.integer :deleter_id
      t.timestamps
    end
  end
end
