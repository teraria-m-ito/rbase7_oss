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

ActiveRecord::Schema[7.0].define(version: 2026_09_30_123000) do
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

  create_table "dwh_caches", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "idnumber", comment: "ユーザID"
    t.text "result", comment: "結果"
    t.string "query_type", comment: "検索タイプ"
    t.string "url", limit: 1024, comment: "URL"
    t.text "params", comment: "パラメータ"
    t.integer "max_age", comment: "保持期間"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_dwh_caches_on_deleted_at"
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

  create_table "ldi_caches", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIキャッシュ", force: :cascade do |t|
    t.string "launch_id", comment: "起動ID"
    t.string "nonce", comment: "ナンス値"
    t.text "data", comment: "キャッシュデータ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_caches_on_deleted_at"
    t.index ["launch_id"], name: "index_ldi_caches_on_launch_id"
    t.index ["nonce"], name: "index_ldi_caches_on_nonce"
  end

  create_table "ldi_competences", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIコンピテンシーマスタ", force: :cascade do |t|
    t.string "competence_cd", comment: "コンピテンシーCD"
    t.string "competence_name", comment: "コンピテンシー名"
    t.text "expression", comment: "コンピテンシー説明"
    t.integer "display_order", comment: "表示順"
    t.bigint "inst_org_id", comment: "学部組織ID"
    t.bigint "dept_org_id", comment: "学科組織ID"
    t.bigint "course_org_id", comment: "コース組織ID"
    t.string "classification", comment: "クラス"
    t.bigint "ldi_rubric_level_id", comment: "LDI達成度ID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_ldi_competences_on_deleted_at"
    t.index ["ldi_rubric_level_id"], name: "index_ldi_competences_on_ldi_rubric_level_id"
  end

  create_table "ldi_converted_dps", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIDP変換テーブル", force: :cascade do |t|
    t.string "from_dp", comment: "変換元DP"
    t.string "to_dp", comment: "変換先DP"
    t.bigint "inst_org_id", comment: "学部組織ID"
    t.bigint "dept_org_id", comment: "学科組織ID"
    t.bigint "first_dept_org_id", comment: "入学時学科ID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_converted_dps_on_deleted_at"
  end

  create_table "ldi_dashboards", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIダッシュボードデータ", force: :cascade do |t|
    t.bigint "site_id", comment: "サイトID"
    t.string "dashboard_type", comment: "ダッシュボードタイプ"
    t.text "layout_json", comment: "レイアウトJSON"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_dashboards_on_deleted_at"
  end

  create_table "ldi_database_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIデータベースサイト", force: :cascade do |t|
    t.bigint "ldi_database_id", comment: "LTIデータベースID"
    t.bigint "site_id", comment: "サイトID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_database_sites_on_deleted_at"
    t.index ["ldi_database_id"], name: "index_ldi_database_sites_on_ldi_database_id"
    t.index ["site_id"], name: "index_ldi_database_sites_on_site_id"
  end

  create_table "ldi_databases", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIデータベース", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "iss", null: false
    t.string "client_id"
    t.string "auth_login_url"
    t.string "auth_token_url"
    t.string "key_set_url"
    t.text "private_key_file"
    t.string "kid"
    t.string "deployment_json"
    t.text "public_key", comment: "公開鍵"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_databases_on_deleted_at"
    t.index ["iss"], name: "index_ldi_databases_on_iss"
  end

  create_table "ldi_general_form_artifacts", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームアーティファクトマスタ", force: :cascade do |t|
    t.bigint "ldi_general_form_manage_id", comment: "LTI入力フォーム管理ID"
    t.string "show_for_div", comment: "入力フォーム区分"
    t.text "alternatives", comment: "選択肢"
    t.integer "allow_upload_number", comment: "アップロード許可数"
    t.string "allow_upload_ext", comment: "アップロード許可拡張子"
    t.bigint "general_form_item_id", comment: "入力フォームアイテムマスタID"
    t.bigint "link_ldi_general_manage_id", comment: "リンク先管理ID"
    t.string "input_example", comment: "定型文"
    t.string "user_attr", comment: "ユーザ属性設定"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_artifacts_on_deleted_at"
    t.index ["ldi_general_form_manage_id"], name: "index_ldi_general_form_artifacts_on_ldi_general_form_manage_id"
  end

  create_table "ldi_general_form_import_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームインポート添付", force: :cascade do |t|
    t.bigint "ldi_general_form_import_id", comment: "LTI入力フォームインポートID"
    t.string "filename", comment: "ファイル名"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "document", comment: "ドキュメント"
    t.string "token", comment: "トークン"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_import_attachments_on_deleted_at"
    t.index ["ldi_general_form_import_id"], name: "index_ldi_showacase_import_atts_import_id"
  end

  create_table "ldi_general_form_import_errors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームインポートエラー", force: :cascade do |t|
    t.bigint "ldi_general_form_import_id", comment: "LTI入力フォームインポートID"
    t.integer "line_no", comment: "行番号"
    t.string "error_message", comment: "エラーメッセージ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_import_errors_on_deleted_at"
    t.index ["ldi_general_form_import_id"], name: "index_ldi_gf_import_errors_on_ldi_general_form_import_id"
  end

  create_table "ldi_general_form_imports", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームインポート", force: :cascade do |t|
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_ldi_general_form_imports_on_deleted_at"
  end

  create_table "ldi_general_form_input_downloads", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム入力ダウンロード", force: :cascade do |t|
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.datetime "requested_at", comment: "作成開始日時"
    t.datetime "compressed_at", comment: "作成完了日時"
    t.string "document", comment: "ドキュメント"
    t.string "filename", comment: "ファイル名"
    t.integer "filesize", comment: "ファイルサイズ"
    t.integer "inclusion_line_num", comment: "行数"
    t.boolean "created", comment: "作成状況"
    t.text "params", comment: "パラメータ"
    t.string "status", comment: "ステータス"
    t.bigint "delayed_jobs_id", comment: "DELAYED_JOB ID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_ldi_general_form_input_downloads_on_deleted_at"
  end

  create_table "ldi_general_form_instructors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム担当教員", force: :cascade do |t|
    t.bigint "ldi_general_form_id", comment: "LTI入力フォームマスタID"
    t.bigint "student_ldi_general_form_participation_id", comment: "LMSユーザID(学生）"
    t.bigint "teacher_ldi_general_form_participation_id", comment: "LMSユーザID(教職員）"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_ldi_general_form_instructors_on_deleted_at"
  end

  create_table "ldi_general_form_journal_import_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームマスタ入力添付", force: :cascade do |t|
    t.bigint "ldi_general_form_journal_import_id", comment: "LTI入力フォーム入力インポートID"
    t.string "filename", comment: "ファイル名"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "document", comment: "ドキュメント"
    t.string "token", comment: "トークン"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_journal_import_attachments_on_deleted_at"
    t.index ["ldi_general_form_journal_import_id"], name: "index_ldi_sc_journal_imp_atts_import_id"
  end

  create_table "ldi_general_form_journal_import_errors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム入力インポートエラー", force: :cascade do |t|
    t.bigint "ldi_general_form_journal_import_id", comment: "LTI入力フォーム入力インポートID"
    t.integer "line_no", comment: "行番号"
    t.string "error_message", comment: "エラーメッセージ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_journal_import_errors_on_deleted_at"
    t.index ["ldi_general_form_journal_import_id"], name: "index_ldi_sc_journal_err_atts_import_id"
  end

  create_table "ldi_general_form_journal_imports", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_journal_imports_on_deleted_at"
  end

  create_table "ldi_general_form_journal_participants", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム入力参加者", force: :cascade do |t|
    t.bigint "ldi_general_form_journal_id", comment: "LTI入力フォームマスタ入力ID"
    t.bigint "ldi_general_form_participant_id", comment: "LTI入力フォーム参加者ID"
    t.datetime "sent_at", comment: "通知日時"
    t.string "send_div", comment: "通知区分"
    t.datetime "answered_at", comment: "回答日時"
    t.datetime "answer_sent_at", comment: "回答通知日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_journal_participants_on_deleted_at"
    t.index ["ldi_general_form_journal_id"], name: "idx_ldi_general_form_journal_participants_rjid"
    t.index ["sent_at"], name: "index_ldi_general_form_journal_participants_on_sent_at"
  end

  create_table "ldi_general_form_journals", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム入力", force: :cascade do |t|
    t.bigint "ldi_general_form_id", comment: "LTI入力フォームマスタID"
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.bigint "submit_from_id", comment: "元入力フォームマスタ入力ID"
    t.integer "field_num", comment: "設問数"
    t.integer "required_field_num", comment: "必須設問数"
    t.integer "input_num", comment: "設問回答数"
    t.integer "required_input_num", comment: "必須設問回答数"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_journals_on_deleted_at"
    t.index ["ldi_general_form_id"], name: "index_ldi_general_form_journals_on_ldi_general_form_id"
    t.index ["lms_user_id"], name: "idx_ldi_general_form_journals_luid"
    t.index ["lms_user_id"], name: "index_ldi_general_form_journals_on_lms_user_id"
    t.index ["submit_from_id"], name: "idx_ldi_general_form_journals_sfid"
    t.index ["submit_from_id"], name: "index_ldi_general_form_journals_on_submit_from_id"
  end

  create_table "ldi_general_form_manage_journal_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム管理入力添付", force: :cascade do |t|
    t.bigint "ldi_general_form_manage_journal_id", comment: "LTI入力フォーム管理入力ID"
    t.string "filename", comment: "ファイル名"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "document", comment: "ドキュメント"
    t.string "token", comment: "トークン"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_manage_journal_attachments_on_deleted_at"
  end

  create_table "ldi_general_form_manage_journal_rubrics", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "ldi_general_form_manage_journal_id", comment: "入力フォーム管理回答ID"
    t.bigint "competence_id", comment: "コンピテンシーID"
    t.string "competence_name", comment: "コンピテンシー名"
    t.string "answer", comment: "回答"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competence_id"], name: "index_ldi_general_form_manage_journal_rubrics_on_competence_id"
  end

  create_table "ldi_general_form_manage_journals", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム管理入力", force: :cascade do |t|
    t.bigint "ldi_general_form_journal_id", comment: "LTI入力フォーム入力ID"
    t.bigint "ldi_general_form_manage_id", comment: "LTI入力フォーム管理ID"
    t.text "answer", comment: "回答"
    t.datetime "answered_at", comment: "回答日時"
    t.bigint "linked_ldi_general_form_manage_journal_id", comment: "リンク先LTI入力ID"
    t.boolean "output_pdf_flag", comment: "PDF出力フラグ"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_manage_journals_on_deleted_at"
    t.index ["ldi_general_form_journal_id"], name: "idx_ldi_general_form_manage_journals_jid"
    t.index ["ldi_general_form_journal_id"], name: "index_ldi_gf_manage_journals_on_ldi_general_form_journal_id"
    t.index ["ldi_general_form_manage_id"], name: "index_ldi_general_form_m_journals_on_ldi_general_form_m_id"
  end

  create_table "ldi_general_form_manages", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム管理マスタ", force: :cascade do |t|
    t.bigint "ldi_general_form_id", comment: "LTI入力フォームID"
    t.boolean "self_assessment_flg", comment: "本人記入対象フラグ"
    t.string "self_assessment_cd", comment: "本人入力タイプCD"
    t.boolean "multi_assessment_flg", comment: "他者記入対象フラグ"
    t.string "multi_assessment_cd", comment: "他者入力タイプCD"
    t.integer "display_order", comment: "表示順"
    t.boolean "required", comment: "必須"
    t.boolean "display_title_flg", comment: "設問タイトル表示フラグ"
    t.string "title", comment: "設問タイトル"
    t.boolean "display_explanation_flg", comment: "設問説明文表示フラグ"
    t.text "explanation", comment: "設問説明文"
    t.bigint "competence_id", comment: "コンピテンシーID"
    t.boolean "allow_display_multi_assessment", comment: "本人記入者への表示許可"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "branch_condition", comment: "分岐条件"
    t.text "display_condition", comment: "表示条件"
    t.index ["deleted_at"], name: "index_ldi_general_form_manages_on_deleted_at"
    t.index ["ldi_general_form_id"], name: "index_ldi_general_form_manages_on_ldi_general_form_id"
    t.index ["multi_assessment_cd"], name: "index_ldi_general_form_manages_on_multi_assessment_cd"
    t.index ["self_assessment_cd"], name: "index_ldi_general_form_manages_on_self_assessment_cd"
  end

  create_table "ldi_general_form_part_import_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム参加者インポート添付", force: :cascade do |t|
    t.bigint "ldi_general_form_part_import_id", comment: "LTI入力フォーム参加者インポートID"
    t.string "filename", comment: "ファイル名"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "document", comment: "ドキュメント"
    t.string "token", comment: "トークン"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_part_import_attachments_on_deleted_at"
    t.index ["ldi_general_form_part_import_id"], name: "index_ldi_general_form_part_import_atts_import_id"
  end

  create_table "ldi_general_form_part_import_datas", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム参加者インポートデータ", force: :cascade do |t|
    t.string "edit_div", comment: "編集区分"
    t.string "general_form_cd", comment: "入力フォームCD"
    t.string "user_id", comment: "ユーザID"
    t.string "role_div", comment: "権限区分"
    t.integer "line_no", comment: "行番号"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ldi_general_form_part_import_errors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム参加者インポートエラー", force: :cascade do |t|
    t.bigint "ldi_general_form_part_import_id", comment: "LTI入力フォーム参加者インポートID"
    t.integer "line_no", comment: "行番号"
    t.string "error_message", comment: "エラーメッセージ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_part_import_errors_on_deleted_at"
    t.index ["ldi_general_form_part_import_id"], name: "index_ldi_general_form_part_import_err_atts_import_id"
  end

  create_table "ldi_general_form_part_student_import_datas", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム参加者担当学生インポートデータ", force: :cascade do |t|
    t.bigint "ldi_general_form_student_import_data_id", comment: "LTI入力フォーム参加者インポートデータID"
    t.string "user_id", comment: "担当学生"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ldi_general_form_participant_imports", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム参加者インポート", force: :cascade do |t|
    t.bigint "site_id", comment: "サイトID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_participant_imports_on_deleted_at"
  end

  create_table "ldi_general_form_participants", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォーム参加者", force: :cascade do |t|
    t.bigint "ldi_general_form_id", comment: "LTI入力フォームマスタID"
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.string "role_div", comment: "権限区分"
    t.datetime "assigned_at", comment: "配布日時"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_participants_on_deleted_at"
    t.index ["ldi_general_form_id"], name: "index_ldi_general_form_participants_on_ldi_general_form_id"
    t.index ["lms_user_id"], name: "index_ldi_general_form_participants_on_lms_user_id"
    t.index ["role_div"], name: "index_ldi_general_form_participants_on_role_div"
  end

  create_table "ldi_general_form_pdf_downloads", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームPDFダウンロード", force: :cascade do |t|
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.datetime "requested_at", comment: "作成開始日時"
    t.datetime "compressed_at", comment: "作成完了日時"
    t.string "document", comment: "ドキュメント"
    t.string "filename", comment: "ファイル名"
    t.integer "filesize", comment: "ファイルサイズ"
    t.integer "inclusion_file_num", comment: "内包PDF数"
    t.boolean "created", comment: "作成状況"
    t.text "params", comment: "パラメータ"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_general_form_pdf_downloads_on_deleted_at"
  end

  create_table "ldi_general_forms", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力フォームマスタ", force: :cascade do |t|
    t.bigint "lti_org_id", comment: "LTI組織ID"
    t.string "general_form_cd", comment: "入力フォームCD"
    t.bigint "ldi_input_category_id", comment: "LTI入力カテゴリID"
    t.string "title", comment: "タイトル"
    t.datetime "start_from", comment: "開始日"
    t.datetime "end_to", comment: "終了日"
    t.boolean "allow_when_overtime", comment: "超過日許可フラグ"
    t.boolean "auto_numbering_flg", comment: "番号自動付与フラグ"
    t.boolean "editable_flg", comment: "編集許可フラグ"
    t.boolean "allow_output_other_assessment_flg", comment: "他者記入出力要否"
    t.bigint "inst_org_id", comment: "学部組織ID"
    t.bigint "dept_org_id", comment: "学科組織ID"
    t.bigint "course_org_id", comment: "コース組織ID"
    t.bigint "copied_from_id", comment: "コピー元id"
    t.integer "copied_by", comment: "コピー者id"
    t.integer "created_by", comment: "作成者id"
    t.string "prio", comment: "優先度"
    t.datetime "publish_start_from", comment: "公開開始日"
    t.datetime "publish_end_to", comment: "公開終了日"
    t.boolean "need_navlink", comment: "ナビリンク表示フラグ"
    t.boolean "general_form_form_editor_registered", default: false, null: false, comment: "フォームエディタの基本情報保存で登録・更新した場合 true"
    t.text "layout_json", comment: "フォームエディタのグリッドレイアウトJSON"
    t.string "page_layout", comment: "ページレイアウト"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "form_type", comment: "フォーム種別"
    t.boolean "enable_pdf", comment: "Pdf出力可否"
    t.boolean "need_assign", comment: "要配布フラグ"
    t.index ["deleted_at"], name: "index_ldi_general_forms_on_deleted_at"
    t.index ["ldi_input_category_id"], name: "idx_ldi_general_forms_icid"
    t.index ["ldi_input_category_id"], name: "index_ldi_general_forms_on_ldi_input_category_id"
  end

  create_table "ldi_information_lms_users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "ldi_information_id", comment: "LTI通知ID"
    t.bigint "lms_user_id", comment: "LMユーザID"
    t.boolean "read"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_information_lms_users_on_deleted_at"
    t.index ["ldi_information_id"], name: "index_ldi_information_lms_users_on_ldi_information_id"
    t.index ["lms_user_id"], name: "index_ldi_information_lms_users_on_lms_user_id"
  end

  create_table "ldi_informations", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI通知", force: :cascade do |t|
    t.text "message", comment: "メッセージ"
    t.string "message_div", comment: "メッセージ区分"
    t.datetime "sent_at", comment: "送信日時"
    t.string "url", comment: "対象URL"
    t.string "send_div", comment: "送信区分"
    t.string "title", comment: "タイトル"
    t.string "issue_id", comment: "申請ID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_ldi_informations_on_deleted_at"
    t.index ["sent_at"], name: "index_ldi_informations_on_sent_at"
  end

  create_table "ldi_input_categories", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力カテゴリー", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.text "meta", comment: "メタ情報"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_order", comment: "表示順"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_ldi_input_categories_on_deleted_at"
  end

  create_table "ldi_input_category_lti_orgs", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI入力カテゴリマスタ組織", force: :cascade do |t|
    t.bigint "ldi_input_category_id", comment: "LTI入力カテゴリID"
    t.bigint "lti_org_id", comment: "LTI組織ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", comment: "削除日時"
    t.index ["deleted_at"], name: "index_ldi_input_category_ldi_orgs_on_deleted_at"
  end

  create_table "ldi_insight_targets", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "ldi_insight_id", comment: "洞察ID"
    t.string "target_type", comment: "対象"
    t.bigint "target_id", comment: "対象ID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_insight_targets_on_deleted_at"
    t.index ["ldi_insight_id"], name: "index_ldi_insight_targets_on_ldi_insight_id"
    t.index ["target_type", "target_id"], name: "index_ldi_insight_targets_on_target_type_and_target_id"
  end

  create_table "ldi_insight_task_histries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "ldi_insight_task_id", comment: "洞察タスクID"
    t.string "status", comment: "ステータス"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_insight_task_histries_on_deleted_at"
    t.index ["ldi_insight_task_id"], name: "index_ldi_insight_task_histries_on_ldi_insight_task_id"
  end

  create_table "ldi_insight_tasks", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LDI洞察タスク", force: :cascade do |t|
    t.string "task_type", comment: "タスク種別"
    t.string "title", comment: "タイトル"
    t.string "cron_expression", comment: "定期実行"
    t.text "description", comment: "説明"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_insight_tasks_on_deleted_at"
  end

  create_table "ldi_insights", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LDI洞察", force: :cascade do |t|
    t.bigint "ldi_insight_task_id", comment: "洞察タスクID"
    t.string "insight_type", comment: "洞察種別"
    t.string "metric", comment: "指標"
    t.string "category", comment: "カテゴリ"
    t.string "title", comment: "タイトル"
    t.text "description", comment: "説明"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_insights_on_deleted_at"
    t.index ["insight_type"], name: "index_ldi_insights_on_insight_type"
    t.index ["ldi_insight_task_id"], name: "index_ldi_insights_on_ldi_insight_task_id"
  end

  create_table "ldi_rubric_descriptions", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LDI達成度アイテム", force: :cascade do |t|
    t.bigint "ldi_rubric_level_id", comment: "LDI達成度ID"
    t.string "description_cd", comment: "達成度アイテムCD"
    t.string "description_name", comment: "達成度アイテム名"
    t.text "description", comment: "達成度アイテム（本文）"
    t.integer "score_from", comment: "開始ポイント"
    t.integer "score_to", comment: "終了ポイント"
    t.integer "score", comment: "評点"
    t.string "grade", comment: "評価記号"
    t.integer "display_order", comment: "表示順"
    t.bigint "ldi_rubric_level_item_master_id", comment: "LDI達成度アイテムマスタID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ldi_rubric_level_id"], name: "index_ldi_rubric_descriptions_on_ldi_rubric_level_id"
    t.index ["ldi_rubric_level_item_master_id"], name: "index_ldi_rubric_descriptions_on_item_master_id"
    t.index ["score_from"], name: "index_ldi_rubric_descriptions_on_score_from"
    t.index ["score_to"], name: "index_ldi_rubric_descriptions_on_score_to"
  end

  create_table "ldi_rubric_level_item_masters", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LDI達成度アイテム", force: :cascade do |t|
    t.bigint "ldi_rubric_level_master_id", comment: "LDI達成度マスタID"
    t.string "item_cd", comment: "達成度アイテムCD"
    t.string "item_name", comment: "達成度アイテム名"
    t.integer "display_order", comment: "表示順"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ldi_rubric_level_master_id"], name: "index_ldi_rdms_on_ldi_rub_level_m_id"
  end

  create_table "ldi_rubric_level_masters", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LDI達成度マスタ", force: :cascade do |t|
    t.string "level_cd", comment: "達成度マスタCD"
    t.string "level_name", comment: "達成度マスタ名"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ldi_rubric_levels", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "level_group_cd", comment: "グループCD"
    t.string "level_group_name", comment: "グループ名"
    t.string "level_cd", comment: "達成度CD"
    t.string "level_name", comment: "達成度名"
    t.string "level_type_cd", comment: "達成度タイプCD"
    t.bigint "inst_org_id", comment: "学部組織ID"
    t.bigint "dept_org_id", comment: "学科組織ID"
    t.bigint "ldi_rubric_level_master_id", comment: "LDI達成度マスタID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dept_org_id"], name: "index_ldi_rubric_levels_on_dept_org_id"
    t.index ["inst_org_id"], name: "index_ldi_rubric_levels_on_inst_org_id"
    t.index ["ldi_rubric_level_master_id"], name: "index_ldi_rubric_levels_on_ldi_rubric_level_master_id"
  end

  create_table "ldi_usages", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI利用ガイド", force: :cascade do |t|
    t.text "message", comment: "利用ガイドメッセージ"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_usages_on_deleted_at"
  end

  create_table "ldi_widget_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIウィジェットマスタサイト", force: :cascade do |t|
    t.bigint "ldi_widget_id", comment: "LTIウィジェットID"
    t.bigint "site_id", comment: "サイトID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_widget_sites_on_deleted_at"
    t.index ["ldi_widget_id"], name: "index_ldi_widget_sites_on_ldi_widget_id"
    t.index ["site_id"], name: "index_ldi_widget_sites_on_site_id"
  end

  create_table "ldi_widgets", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIウィジェットマスタ", force: :cascade do |t|
    t.string "widget_code", comment: "ウィジェットコード"
    t.string "name", comment: "ウィジェット名称"
    t.text "explanation", comment: "内容"
    t.text "script", comment: "script記述"
    t.text "css", comment: "CSS記述"
    t.boolean "available", comment: "有効フラグ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ldi_widgets_on_deleted_at"
  end

  create_table "lms_user_custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "lms_user_id"
    t.bigint "custom_field_id"
    t.string "field_value"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_lms_user_custom_fields_on_custom_field_id"
    t.index ["deleted_at"], name: "index_lms_user_custom_fields_on_deleted_at"
    t.index ["lms_user_id"], name: "index_lms_user_custom_fields_on_lms_user_id"
  end

  create_table "lms_user_import_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LMSユーザインポート添付", force: :cascade do |t|
    t.bigint "lms_user_import_id", comment: "LTI振り返りインポートID"
    t.string "filename", comment: "ファイル名"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "document", comment: "ドキュメント"
    t.string "token", comment: "トークン"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lms_user_import_attachments_on_deleted_at"
    t.index ["lms_user_import_id"], name: "index_lms_user_import_atts_import_id"
  end

  create_table "lms_user_import_errors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LMSユーザインポートエラー", force: :cascade do |t|
    t.bigint "lms_user_import_id", comment: "LMSユーザインポートID"
    t.integer "line_no", comment: "行番号"
    t.string "error_message", comment: "エラーメッセージ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lms_user_import_errors_on_deleted_at"
    t.index ["lms_user_import_id"], name: "index_lms_user_import_errors_on_lms_user_import_id"
  end

  create_table "lms_user_imports", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LMSユーザインポート", force: :cascade do |t|
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_lms_user_imports_on_deleted_at"
  end

  create_table "lms_user_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LMSユーザサイト", force: :cascade do |t|
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.bigint "site_id", comment: "サイトID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lms_user_sites_on_deleted_at"
    t.index ["lms_user_id"], name: "index_lms_user_sites_on_lms_user_id"
    t.index ["site_id"], name: "index_lms_user_sites_on_site_id"
  end

  create_table "lms_users", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LMSユーザ", force: :cascade do |t|
    t.string "username", comment: "ユーザID"
    t.string "name", comment: "氏名"
    t.string "given_name", comment: "姓"
    t.string "family_name", comment: "名"
    t.string "email", comment: "Eメール"
    t.string "lms", comment: "登録元LMS"
    t.string "role", comment: "権限"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lti_org_id", comment: "LTI組織ID"
    t.bigint "inst_org_id", comment: "学部組織ID"
    t.bigint "dept_org_id", comment: "学科組織ID"
    t.bigint "course_org_id", comment: "コース組織ID"
    t.bigint "admin_user_id", comment: "ユーザID"
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.index ["deleted_at"], name: "index_lms_users_on_deleted_at"
  end

  create_table "lti_caches", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIキャッシュ", force: :cascade do |t|
    t.string "launch_id", comment: "起動ID"
    t.string "nonce", comment: "ナンス値"
    t.text "data", comment: "キャッシュデータ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lti_caches_on_deleted_at"
    t.index ["launch_id"], name: "index_lti_caches_on_launch_id"
    t.index ["nonce"], name: "index_lti_caches_on_nonce"
  end

  create_table "lti_database_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIデータベースサイト", force: :cascade do |t|
    t.bigint "lti_database_id", comment: "LTIデータベースID"
    t.bigint "site_id", comment: "サイトID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lti_database_sites_on_deleted_at"
    t.index ["lti_database_id"], name: "index_lti_database_sites_on_lti_database_id"
    t.index ["site_id"], name: "index_lti_database_sites_on_site_id"
  end

  create_table "lti_databases", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIデータベース", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "iss", null: false
    t.string "client_id"
    t.string "auth_login_url"
    t.string "auth_token_url"
    t.string "key_set_url"
    t.text "private_key_file"
    t.string "kid"
    t.string "deployment_json"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "public_key", comment: "公開鍵"
    t.index ["deleted_at"], name: "index_lti_databases_on_deleted_at"
    t.index ["iss"], name: "index_lti_databases_on_iss"
  end

  create_table "lti_import_histories", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTIインポート履歴", force: :cascade do |t|
    t.string "target_type", comment: "インポートタイプ"
    t.bigint "target_id", comment: "履歴ID"
    t.bigint "provider_job_id", comment: "delayed_job ID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_lti_import_histories_on_deleted_at"
    t.index ["target_type", "target_id"], name: "index_lti_import_histories_on_target_type_and_target_id", unique: true
  end

  create_table "lti_operation_logs", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI操作ログ", force: :cascade do |t|
    t.datetime "operated_at", comment: "操作日時"
    t.string "form_type", comment: "対象"
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.string "user_id", comment: "ユーザID"
    t.string "user_name", comment: "ユーザ名"
    t.bigint "inst_org_id", comment: "学部ID"
    t.string "institution", comment: "学部名"
    t.bigint "dept_org_id", comment: "学科ID"
    t.string "department", comment: "学科名"
    t.bigint "course_org_id", comment: "コースID"
    t.string "operation_log_target_type", comment: "対象"
    t.bigint "operation_log_target_id", comment: "フォームID"
    t.string "screen_name", comment: "画面名"
    t.string "operation_div", comment: "操作区分"
    t.text "description", comment: "説明"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.integer "input_category_id", comment: "カテゴリID"
    t.string "input_category_name", comment: "カテゴリ名"
    t.integer "form_cd", comment: "フォームCD"
    t.string "form_name", comment: "フォーム名"
    t.index ["deleted_at"], name: "index_lti_operation_logs_on_deleted_at"
  end

  create_table "lti_org_import_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI組織インポート添付", force: :cascade do |t|
    t.integer "lti_org_import_id", comment: "LTI組織インポートID"
    t.string "filename", comment: "ファイル名"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "document", comment: "ドキュメント"
    t.string "token", comment: "トークン"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lti_org_import_attachments_on_deleted_at"
    t.index ["lti_org_import_id"], name: "index_lti_org_import_atts_import_id"
  end

  create_table "lti_org_import_errors", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI組織インポートエラー", force: :cascade do |t|
    t.integer "lti_org_import_id", comment: "LTI組織インポートID"
    t.integer "line_no", comment: "行番号"
    t.string "error_message", comment: "エラーメッセージ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_lti_org_import_errors_on_deleted_at"
    t.index ["lti_org_import_id"], name: "index_lti_org_import_errors_on_lti_org_import_id"
  end

  create_table "lti_org_imports", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI組織インポート", force: :cascade do |t|
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id", comment: "作成ユーザID"
    t.integer "updater_id", comment: "更新ユーザID"
    t.integer "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_lti_org_imports_on_deleted_at"
  end

  create_table "lti_orgs", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI組織", force: :cascade do |t|
    t.string "org_cd", comment: "組織CD"
    t.string "org_name", comment: "組織名"
    t.bigint "parent_org_id", comment: "親組織CD"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "org_div", comment: "組織区分"
    t.string "ancestry", comment: "階層"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_lti_orgs_on_deleted_at"
    t.index ["org_cd"], name: "index_lti_orgs_on_org_cd"
  end

  create_table "lti_usages", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LTI利用ガイド", force: :cascade do |t|
    t.text "message", comment: "利用ガイドメッセージ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.index ["deleted_at"], name: "index_lti_usages_on_deleted_at"
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
    t.boolean "enable", comment: "有効フラグ"
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

  create_table "wid_dashboards", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "site_id", comment: "サイトID"
    t.string "dashboard_name", comment: "ダッシュボード名"
    t.text "layout_json", comment: "レイアウトJSON"
    t.integer "creator_id", comment: "作成ユーザID"
    t.integer "updater_id", comment: "更新ユーザID"
    t.integer "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wid_lms_user_dashboards", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "LMSユーザ別ダッシュボード", force: :cascade do |t|
    t.bigint "lms_user_id", comment: "LMSユーザID"
    t.bigint "site_id", comment: "サイトID"
    t.string "dashboard_name", comment: "ダッシュボード名"
    t.text "layout_json", comment: "レイアウトJSON"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_wid_lms_user_dashboards_on_deleted_at"
    t.index ["lms_user_id", "site_id", "dashboard_name"], name: "index_wid_lms_user_dashboards_on_user_site_name"
  end

  create_table "wid_widget_sites", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "ウィジェットマスタサイト", force: :cascade do |t|
    t.bigint "wid_widget_id", comment: "ウィジェットID"
    t.integer "site_id", comment: "サイトID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_widget_sites_on_deleted_at"
    t.index ["site_id"], name: "index_widget_sites_on_site_id"
    t.index ["wid_widget_id"], name: "index_widget_sites_on_widget_id"
  end

  create_table "wid_widgets", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "ウィジェットマスタ", force: :cascade do |t|
    t.string "widget_code", comment: "ウィジェットコード"
    t.string "name", comment: "ウィジェット名称"
    t.text "explanation", comment: "内容"
    t.text "script", comment: "script記述"
    t.text "css", comment: "CSS記述"
    t.boolean "available", comment: "有効フラグ"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_widgets_on_deleted_at"
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
