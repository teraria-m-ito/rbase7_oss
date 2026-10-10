class AddUserstampColumnsToTables < ActiveRecord::Migration[7.0]
  # セッション・ライブラリ管理のテーブル（delayed_jobs、versions）・マスタ（ken_all_postal_codes）は対象外
  TABLES = %i[
    admin_settings
    admin_user_attachments
    admin_user_custom_fields
    admin_user_sites
    admin_users
    custom_field_sites
    custom_fields
    issue_custom_fields
    issue_targets
    issue_type_sites
    issue_types
    mail_template_sites
    mail_templates
    queries
    report_attachments
    report_sites
    reports
    role_actions
    role_role_actions
    roles
    sites
    state_flow_workflow_states
    state_flows
    system_setting_attachments
    system_setting_sites
    system_settings
    translations
    workflow_sites
    workflow_states
    workflows
  ].freeze

  def up
    TABLES.each do |table|
      add_column table, :creator_id, :bigint, comment: "作成ユーザID" unless column_exists?(table, :creator_id)
      add_column table, :updater_id, :bigint, comment: "更新ユーザID" unless column_exists?(table, :updater_id)
      # 論理削除しないテーブルでは削除者を記録できないため追加しない
      if column_exists?(table, :deleted_at) && !column_exists?(table, :deleter_id)
        add_column table, :deleter_id, :bigint, comment: "削除ユーザID"
      end
    end
  end

  def down
    TABLES.each do |table|
      %i[deleter_id updater_id creator_id].each do |column|
        remove_column table, column if column_exists?(table, column)
      end
    end
  end
end
