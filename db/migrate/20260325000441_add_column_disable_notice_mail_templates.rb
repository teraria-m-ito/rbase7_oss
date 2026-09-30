class AddColumnDisableNoticeMailTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :mail_templates, :disable_notice, :boolean, comment: "通知無効フラグ"
  end
end
