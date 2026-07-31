# frozen_string_literal: true

# 他テーブル参照用の integer 型カラム（外部キー相当）を bigint に揃える
# 非対象: file_size, line_no, sign_in_count, field_size, display_order, priority, attempts, canvasapi_storage_quota_mb 等
class ChangeIntegerForeignKeyColumnsToBigint < ActiveRecord::Migration[7.0]
  FKS = {
    admin_user_attachments: %i[admin_user_id],
    admin_user_custom_fields: %i[admin_user_id custom_field_id],
    admin_user_sites: %i[admin_user_id site_id],
    admin_users: %i[role_id],
    canvas_course_custom_fields: %i[canvas_course_id custom_field_id],
    canvas_enrollment_terms: %i[creator_id updater_id deleter_id],
    canvas_enrollments: %i[creator_id updater_id deleter_id],
    canvas_sections: %i[creator_id updater_id deleter_id],
    canvas_usages: %i[creator_id updater_id deleter_id],
    canvas_user_custom_fields: %i[canvas_user_id custom_field_id],
    canvas_users: %i[creator_id updater_id deleter_id],
    custom_field_sites: %i[custom_field_id site_id],
    issue_custom_fields: %i[issue_id custom_field_id],
    issue_targets: %i[issue_id],
    issue_type_sites: %i[issue_type_id site_id],
    issues: %i[
      site_id
      issue_type_id
      workflow_state_id
      prev_workflow_state_id
      assigned_id
      issued_id
      creator_id
      updater_id
      deleter_id
    ],
    mail_template_sites: %i[mail_template_id site_id],
    queries: %i[admin_user_id],
    report_attachments: %i[report_id],
    report_sites: %i[report_id site_id],
    role_role_actions: %i[role_id role_action_id],
    state_flow_workflow_states: %i[state_flow_id current_workflow_state_id next_workflow_state_id],
    state_flows: %i[workflow_id role_id],
    system_setting_attachments: %i[system_setting_id],
    system_setting_sites: %i[system_setting_id site_id],
    workflow_sites: %i[workflow_id site_id],
    workflow_states: %i[workflow_id],
    workflows: %i[issue_type_id],
  }.freeze

  def up
    FKS.each do |table, columns|
      next unless table_exists?(table)

      columns.each do |column|
        next unless column_exists?(table, column)

        change_column table, column, :bigint
      end
    end
  end

  def down
    FKS.each do |table, columns|
      next unless table_exists?(table)

      columns.each do |column|
        next unless column_exists?(table, column)

        change_column table, column, :integer
      end
    end
  end
end
