class CreateSystemSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :system_settings do |t|
      t.string :setting_category_div, limit: 20
      t.string :setting_div, limit: 20
      t.string :setting_value, limit: 1000
      t.datetime :deleted_at, index: true
      
      t.timestamps
    end
  end
end
