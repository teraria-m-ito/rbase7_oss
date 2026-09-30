class CreateRoleRoleAction < ActiveRecord::Migration[6.0]
  def change
    create_table :role_role_actions do |t|
      t.integer  :role_id, index: true
      t.integer  :role_action_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
