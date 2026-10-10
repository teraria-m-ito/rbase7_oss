# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_07_31_211347) do
  create_table "admin_settings", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "use_login_id"
    t.string "locale"
    t.string "time_zone"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_admin_settings_on_deleted_at"
    t.index ["use_login_id"], name: "index_admin_settings_on_use_login_id"
  end

  create_table "admin_user_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.string "filename"
    t.integer "file_size"
    t.string "document"
    t.string "token"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_admin_user_attachments_on_admin_user_id"
    t.index ["deleted_at"], name: "index_admin_user_attachments_on_deleted_at"
  end

  create_table "admin_user_custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "custom_field_id"
    t.string "field_value"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_admin_user_custom_fields_on_admin_user_id"
    t.index ["custom_field_id"], name: "index_admin_user_custom_fields_on_custom_field_id"
    t.index ["deleted_at"], name: "index_admin_user_custom_fields_on_deleted_at"
  end

  create_table "admin_user_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_admin_user_sites_on_admin_user_id"
    t.index ["deleted_at"], name: "index_admin_user_sites_on_deleted_at"
    t.index ["site_id"], name: "index_admin_user_sites_on_site_id"
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.bigint "role_id"
    t.string "status_div", default: "before_apply"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "login_from", comment: "ログイン元"
    t.string "sso_session_id", comment: "SSOセッションID"
    t.index ["deleted_at"], name: "index_admin_users_on_deleted_at"
    t.index ["role_id"], name: "index_admin_users_on_role_id"
  end

  create_table "custom_field_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "custom_field_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_sites_on_custom_field_id"
    t.index ["deleted_at"], name: "index_custom_field_sites_on_deleted_at"
    t.index ["site_id"], name: "index_custom_field_sites_on_site_id"
  end

  create_table "custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "custom_field_type"
    t.string "issue_type"
    t.string "field_name"
    t.string "field_type"
    t.string "format_regexp"
    t.boolean "required"
    t.string "default_value"
    t.integer "field_size"
    t.string "comment", limit: 1000
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name", comment: "フィールド表示名"
    t.integer "display_order", comment: "表示順"
    t.boolean "search_cond", comment: "検索条件表示"
    t.boolean "display_result_list", comment: "検索結果表示"
    t.index ["deleted_at"], name: "index_custom_fields_on_deleted_at"
  end

  create_table "delayed_jobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "issue_custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "issue_id"
    t.bigint "custom_field_id"
    t.string "field_value"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_issue_custom_fields_on_custom_field_id"
    t.index ["deleted_at"], name: "index_issue_custom_fields_on_deleted_at"
    t.index ["issue_id"], name: "index_issue_custom_fields_on_issue_id"
  end

  create_table "issue_targets", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "申請対象", force: :cascade do |t|
    t.bigint "issue_id", comment: "申請ID"
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_issue_targets_on_deleted_at"
    t.index ["issue_id"], name: "index_issue_targets_on_issue_id"
    t.index ["target_type", "target_id"], name: "index_issue_targets_on_target"
  end

  create_table "issue_type_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "issue_type_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_issue_type_sites_on_deleted_at"
    t.index ["issue_type_id"], name: "index_issue_type_sites_on_issue_type_id"
    t.index ["site_id"], name: "index_issue_type_sites_on_site_id"
  end

  create_table "issue_types", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "issue_type_name"
    t.string "issue_type_class"
    t.string "issue_type_short_name"
    t.boolean "deletable"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_issue_types_on_deleted_at"
    t.index ["issue_type_short_name"], name: "index_issue_types_on_issue_type_short_name"
  end

  create_table "issues", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "site_id"
    t.bigint "issue_type_id"
    t.bigint "workflow_state_id"
    t.bigint "prev_workflow_state_id"
    t.string "priority"
    t.string "title"
    t.string "expression", limit: 1000
    t.bigint "assigned_id"
    t.bigint "issued_id"
    t.datetime "limited_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "creator_id"
    t.bigint "updater_id"
    t.bigint "deleter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_issues_on_deleted_at"
    t.index ["issue_type_id"], name: "index_issues_on_issue_type_id"
    t.index ["prev_workflow_state_id"], name: "index_issues_on_prev_workflow_state_id"
    t.index ["site_id"], name: "index_issues_on_site_id"
    t.index ["workflow_state_id"], name: "index_issues_on_workflow_state_id"
  end

  create_table "job_manage_errors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "JOB管理エラー", force: :cascade do |t|
    t.bigint "job_manage_id", comment: "JOB管理ID"
    t.string "message", comment: "エラーメッセージ"
    t.integer "row_no", comment: "行番号"
    t.string "target_name", comment: "対象名"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_job_manage_errors_on_deleted_at"
  end

  create_table "job_manages", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "ジョブ管理", force: :cascade do |t|
    t.string "active_job_id", comment: "ジョブID"
    t.string "job_type", comment: "ジョブタイプ"
    t.string "status", comment: "ステータス"
    t.bigint "request_by", comment: "要求者ID"
    t.datetime "requested_at", comment: "要求日時"
    t.datetime "started_at", comment: "開始日時"
    t.datetime "finished_at", comment: "終了日時"
    t.integer "spent", comment: "経過時間"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_message", comment: "ステータス表示"
    t.index ["active_job_id"], name: "index_job_manages_on_active_job_id"
    t.index ["deleted_at"], name: "index_job_manages_on_deleted_at"
  end

  create_table "ken_all_postal_codes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "code"
    t.text "address1"
    t.text "address2"
    t.text "address3"
    t.text "address_kana1"
    t.text "address_kana2"
    t.text "address_kana3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_ken_all_postal_codes_on_code"
  end

  create_table "mail_template_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "mail_template_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_mail_template_sites_on_deleted_at"
    t.index ["mail_template_id"], name: "index_mail_template_sites_on_mail_template_id"
    t.index ["site_id"], name: "index_mail_template_sites_on_site_id"
  end

  create_table "mail_templates", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "template_div"
    t.string "template_name"
    t.string "from_address"
    t.string "to_address"
    t.string "subject"
    t.string "body", limit: 1000
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disable_notice", comment: "通知無効フラグ"
    t.index ["deleted_at"], name: "index_mail_templates_on_deleted_at"
  end

  create_table "queries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "admin_user_id"
    t.string "title"
    t.string "query_content", limit: 1000
    t.string "target_class"
    t.string "query_fields", limit: 1000
    t.string "selected_query_fields", limit: 1000
    t.boolean "shared"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_queries_on_admin_user_id"
    t.index ["deleted_at"], name: "index_queries_on_deleted_at"
  end

  create_table "report_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "report_id"
    t.string "filename"
    t.integer "file_size"
    t.string "document"
    t.string "token"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_report_attachments_on_deleted_at"
    t.index ["report_id"], name: "index_report_attachments_on_report_id"
  end

  create_table "report_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "report_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_report_sites_on_deleted_at"
    t.index ["report_id"], name: "index_report_sites_on_report_id"
    t.index ["site_id"], name: "index_report_sites_on_site_id"
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title"
    t.string "report_class"
    t.string "description", limit: 1000
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_reports_on_deleted_at"
  end

  create_table "role_actions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "controller_name"
    t.string "controller_path"
    t.string "display_name"
    t.string "action_name"
    t.string "action_display_name"
    t.string "auth_as"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_role_actions_on_deleted_at"
  end

  create_table "role_role_actions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "role_action_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_role_role_actions_on_deleted_at"
    t.index ["role_action_id"], name: "index_role_role_actions_on_role_action_id"
    t.index ["role_id"], name: "index_role_role_actions_on_role_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "role_name"
    t.string "role_short_name"
    t.boolean "deletable"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "site_name"
    t.string "status_div", default: "before_apply"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sites_on_deleted_at"
  end

  create_table "state_flow_workflow_states", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "state_flow_id"
    t.bigint "current_workflow_state_id"
    t.bigint "next_workflow_state_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_workflow_state_id"], name: "index_state_flow_workflow_states_on_current_workflow_state_id"
    t.index ["deleted_at"], name: "index_state_flow_workflow_states_on_deleted_at"
    t.index ["next_workflow_state_id"], name: "index_state_flow_workflow_states_on_next_workflow_state_id"
    t.index ["state_flow_id"], name: "index_state_flow_workflow_states_on_state_flow_id"
  end

  create_table "state_flows", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "workflow_id"
    t.bigint "role_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_state_flows_on_deleted_at"
    t.index ["role_id"], name: "index_state_flows_on_role_id"
    t.index ["workflow_id"], name: "index_state_flows_on_workflow_id"
  end

  create_table "system_setting_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "system_setting_id"
    t.string "type_div"
    t.string "filename"
    t.integer "file_size"
    t.string "document"
    t.string "token"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_system_setting_attachments_on_deleted_at"
    t.index ["system_setting_id"], name: "index_system_setting_attachments_on_system_setting_id"
  end

  create_table "system_setting_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "system_setting_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_system_setting_sites_on_deleted_at"
    t.index ["site_id"], name: "index_system_setting_sites_on_site_id"
    t.index ["system_setting_id"], name: "index_system_setting_sites_on_system_setting_id"
  end

  create_table "system_settings", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "setting_category_div", limit: 20
    t.string "setting_div", limit: 20
    t.string "setting_value", limit: 16000, comment: "設定値"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_system_settings_on_deleted_at"
  end

  create_table "translations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "scope"
    t.string "locale"
    t.string "key"
    t.text "value"
    t.text "interpolations"
    t.boolean "is_proc", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "workflow_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "workflow_id"
    t.bigint "site_id"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_workflow_sites_on_deleted_at"
    t.index ["site_id"], name: "index_workflow_sites_on_site_id"
    t.index ["workflow_id"], name: "index_workflow_sites_on_workflow_id"
  end

  create_table "workflow_states", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "workflow_id"
    t.string "state_cd"
    t.string "state_name"
    t.boolean "default_value"
    t.boolean "end_point"
    t.integer "display_order"
    t.boolean "deleted_state"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_workflow_states_on_deleted_at"
  end

  create_table "workflows", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "workflow_name"
    t.bigint "issue_type_id"
    t.boolean "deletable"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_workflows_on_deleted_at"
    t.index ["issue_type_id"], name: "index_workflows_on_issue_type_id"
  end

end
