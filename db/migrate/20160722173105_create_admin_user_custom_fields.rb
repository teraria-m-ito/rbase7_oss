class CreateAdminUserCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_user_custom_fields do |t|
      t.integer :admin_user_id, index: true
      t.integer :custom_field_id, index: true
      t.string  :field_value

      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
