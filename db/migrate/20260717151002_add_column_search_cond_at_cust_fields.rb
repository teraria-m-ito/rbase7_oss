class AddColumnSearchCondAtCustFields < ActiveRecord::Migration[7.0]
  def change
    add_column :custom_fields, :search_cond, :boolean, comment: "検索条件表示"
    add_column :custom_fields, :display_result_list, :boolean, comment: "検索結果表示"
  end
end
