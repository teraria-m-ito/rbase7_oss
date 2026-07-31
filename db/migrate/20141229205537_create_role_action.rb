class CreateRoleAction < ActiveRecord::Migration[6.0]
  def change
    create_table :role_actions do |t|
      t.string  :controller_name
      t.string  :controller_path
      t.string  :display_name
      t.string  :action_name
      t.string  :action_display_name
      t.string  :auth_as
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
