class CreateReportAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :report_attachments do |t|
      t.integer  :report_id, index: true
      t.string   :filename
      t.integer   :file_size
      t.string   :document
      t.string   :token
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
