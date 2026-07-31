class CreateCustomFieldSites < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_field_sites do |t|
      t.integer  :custom_field_id, index: true
      t.integer  :site_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
