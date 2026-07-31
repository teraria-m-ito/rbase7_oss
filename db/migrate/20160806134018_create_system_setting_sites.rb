class CreateSystemSettingSites < ActiveRecord::Migration[6.0]
  def change
    create_table :system_setting_sites do |t|
      t.integer  :system_setting_id, index: true
      t.integer  :site_id, index: true
      t.datetime :deleted_at, index: true
     t.timestamps
    end
  end
end
