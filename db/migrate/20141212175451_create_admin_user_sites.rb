class CreateAdminUserSites < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_user_sites do |t|
      t.integer  :admin_user_id, index: true
      t.integer  :site_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
