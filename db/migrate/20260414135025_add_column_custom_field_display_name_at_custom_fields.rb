class AddColumnCustomFieldDisplayNameAtCustomFields < ActiveRecord::Migration[7.0]
  def change
    add_column :custom_fields, :display_name, :string, comment: "フィールド表示名"
  end
end
