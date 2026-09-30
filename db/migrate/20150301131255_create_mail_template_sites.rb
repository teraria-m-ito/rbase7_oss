class CreateMailTemplateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_template_sites do |t|
      t.integer  :mail_template_id, index: true
      t.integer  :site_id, index: true
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
