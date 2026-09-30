class CreateIssueCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_custom_fields do |t|
      t.integer :issue_id, index: true
      t.integer :custom_field_id, index: true
      t.string  :field_value

      t.datetime :deleted_at, index: true
      t.timestamps      
    end
  end
end
