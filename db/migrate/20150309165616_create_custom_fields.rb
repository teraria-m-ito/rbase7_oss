class CreateCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_fields do |t|
      t.string :custom_field_type
      t.string :issue_type
      t.string :field_name
      t.string :field_type
      t.string :format_regexp
      t.boolean :required
      t.string :default_value
      t.integer :field_size
      t.string :comment, limit: 1000
      
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
