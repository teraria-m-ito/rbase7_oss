class CreateMailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :mail_templates do |t|
      t.string :template_div
      t.string :template_name
      t.string :from_address
      t.string :to_address
      t.string :subject
      t.string :body, limit: 1000
      t.datetime :deleted_at, index: true
      
      t.timestamps
    end
  end
end
