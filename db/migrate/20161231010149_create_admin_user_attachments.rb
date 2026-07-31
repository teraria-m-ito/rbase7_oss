class CreateAdminUserAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_user_attachments do |t|
      t.integer  :admin_user_id, index: true
      t.string   :filename
      t.integer  :file_size
      t.string   :document
      t.string   :token
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
