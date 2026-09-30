class CreateAdminSetting < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_settings do |t|
      t.boolean :use_login_id, index: true
      t.string :locale
      t.string :time_zone
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
