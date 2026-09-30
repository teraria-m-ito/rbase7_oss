class CreateIssueTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_types do |t|
      t.string :issue_type_name
      t.string :issue_type_class
      t.string :issue_type_short_name, index: true
      t.boolean :deletable
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
