class CreateSystemSettingAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :system_setting_attachments do |t|
      t.integer  :system_setting_id, index: true
      t.string   :type_div
      t.string   :filename
      t.integer  :file_size
      t.string   :document
      t.string   :token
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
