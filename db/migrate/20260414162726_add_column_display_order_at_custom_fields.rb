class AddColumnDisplayOrderAtCustomFields < ActiveRecord::Migration[7.0]
  def change
    add_column :custom_fields, :display_order, :integer, comment: "表示順"
  end
end
