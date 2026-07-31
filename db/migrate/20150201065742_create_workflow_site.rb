class CreateWorkflowSite < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_sites do |t|
      t.integer  :workflow_id, index: true
      t.integer  :site_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
