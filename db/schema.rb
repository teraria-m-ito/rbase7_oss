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

ActiveRecord::Schema[7.0].define(version: 2026_07_26_164300) do
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

  create_table "canvas_accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CAVASサブアカウント", force: :cascade do |t|
    t.bigint "parent_canvas_account_id", comment: "親CAVASサブアカウントID"
    t.bigint "parent_account_id", comment: "親アカウントID"
    t.bigint "canvasapi_account_id", comment: "CAVASサブアカウントID"
    t.string "canvasapi_account_name", comment: "CANVASサブアカウント名"
    t.string "account_name", comment: "サブアカウント名"
    t.string "ancestry", comment: "階層"
    t.string "canvasapi_parent_account_id", comment: "APIで取得した親アカウントID"
    t.string "canvasapi_uuid", comment: "UUID"
    t.boolean "update_lock", default: false, comment: "更新ロック"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_accounts_on_deleted_at"
    t.index ["parent_account_id"], name: "index_canvas_accounts_on_parent_account_id"
    t.index ["parent_canvas_account_id"], name: "index_canvas_accounts_on_parent_canvas_account_id"
  end

  create_table "canvas_admins", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVAS管理者", force: :cascade do |t|
    t.bigint "account_id", comment: "アカウントID"
    t.bigint "canvasapi_admin_id", comment: "CANVAS管理者ID"
    t.string "canvasapi_role", comment: "CANVASロール名"
    t.bigint "canvasapi_role_id", comment: "CANVASロールID"
    t.bigint "role_id", comment: "ロールID"
    t.bigint "canvasapi_user_id", comment: "CANVASユーザID"
    t.bigint "user_id", comment: "ユーザID"
    t.string "canvasapi_workflow_state", comment: "CANVASロール状態"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["canvasapi_admin_id"], name: "index_canvas_admins_on_canvasapi_admin_id"
    t.index ["deleted_at"], name: "index_canvas_admins_on_deleted_at"
    t.index ["user_id"], name: "index_canvas_admins_on_user_id"
  end

  create_table "canvas_course_blueprints", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASコースブループリント", force: :cascade do |t|
    t.bigint "course_id", comment: "コースID"
    t.bigint "canvas_associated_course_id", comment: "関連コースID(関連）"
    t.bigint "associated_course_id", comment: "関連コースID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["associated_course_id"], name: "index_canvas_course_blueprints_on_associated_course_id"
    t.index ["canvas_associated_course_id"], name: "index_canvas_course_blueprints_on_canvas_associated_course_id"
    t.index ["course_id"], name: "index_canvas_course_blueprints_on_course_id"
    t.index ["deleted_at"], name: "index_canvas_course_blueprints_on_deleted_at"
  end

  create_table "canvas_course_custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASコースのカスタムフィールド", force: :cascade do |t|
    t.integer "course_id", comment: "CANVASコースID"
    t.integer "custom_field_id", comment: "カスタムフィールドID"
    t.string "field_value", comment: "カスタムフィールド値"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_canvas_course_custom_fields_on_course_id"
    t.index ["custom_field_id"], name: "index_canvas_course_custom_fields_on_custom_field_id"
    t.index ["deleted_at"], name: "index_canvas_course_custom_fields_on_deleted_at"
  end

  create_table "canvas_courses", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASコース", force: :cascade do |t|
    t.bigint "canvasapi_course_id", comment: "CANVASコースID"
    t.string "canvasapi_name", comment: "CANVASコース名"
    t.string "name", comment: "コース名"
    t.string "name_en", comment: "コース名(英語）"
    t.string "canvasapi_course_code", comment: "CANVASコースCD"
    t.string "course_code", comment: "コースCD"
    t.bigint "canvasapi_account_id", comment: "CANVASアカウントID"
    t.bigint "canvas_account_id", comment: "アカウントID(連携）"
    t.bigint "account_id", comment: "アカウントID"
    t.datetime "canvasapi_created_at", comment: "CANVASコース作成日時"
    t.datetime "canvasapi_start_at", comment: "CANVASコース開始日時"
    t.datetime "start_at", comment: "コース開始日時"
    t.datetime "canvasapi_end_at", comment: "CANVASコース終了日時"
    t.datetime "end_at", comment: "コース終了日時"
    t.string "canvasapi_default_view", comment: "CANVASデフォルトビュー"
    t.string "default_view", comment: "デフォルトビュー"
    t.bigint "canvasapi_enrollment_term_id", comment: "CANVAS学期ID"
    t.bigint "canvas_enrollment_term_id", comment: "学期ID(連携)"
    t.bigint "enrollment_term_id", comment: "学期ID"
    t.boolean "canvasapi_is_public", comment: "CANVAS公開"
    t.boolean "is_public", comment: "公開"
    t.bigint "canvasapi_grading_standard_id", comment: "CANVAS成績標準ID"
    t.bigint "grading_standard_id", comment: "成績標準ID"
    t.bigint "canvasapi_root_account_id", comment: "CANVASルートアカウントID"
    t.bigint "canvas_root_account_id", comment: "ルートアカウントID（連携）"
    t.bigint "root_account_id", comment: "ルートアカウントID"
    t.string "canvasapi_uuid", comment: "UUID"
    t.string "canvasapi_licence", comment: "CANVASライセンス"
    t.string "licence", comment: "ライセンス"
    t.string "canvasapi_grade_passback_setting", comment: "CANVAS成績渡し設定"
    t.string "grade_passback_setting", comment: "成績渡し設定"
    t.text "canvasapi_syllabus_body", comment: "CANVASシラバス本文"
    t.text "syllabus_body", comment: "シラバス本文"
    t.boolean "canvasapi_public_syllabus", comment: "CANVASシラバス公開"
    t.boolean "public_syllabus", comment: "シラバス公開"
    t.boolean "canvasapi_public_syllabus_to_auth", comment: "CANVASシラバス認証ユーザに公開"
    t.boolean "public_syllabus_to_auth", comment: "シラバス認証ユーザに公開"
    t.boolean "canvasapi_is_public_to_auth_users", comment: "CANVAS認証ユーザに公開"
    t.boolean "is_public_to_auth_users", comment: "認証ユーザに公開"
    t.integer "canvasapi_storage_quota_mb", comment: "CANVASストレージ容量(MB)"
    t.integer "storage_quota_mb", comment: "ストレージ容量(MB)"
    t.boolean "canvasapi_homeroom_course", comment: "CANVASホームルームコース"
    t.boolean "homeroom_course", comment: "ホームルームコース"
    t.string "canvasapi_course_color", comment: "CANVASコースカラー"
    t.string "course_color", comment: "コースカラー"
    t.string "canvasapi_friendly_name", comment: "CANVASコースフレンドリー名"
    t.string "friendly_name", comment: "コースフレンドリー名"
    t.boolean "canvasapi_apply_assignment_group_weights", comment: "CANVAS成績グループ重み適用"
    t.boolean "apply_assignment_group_weights", comment: "成績グループ重み適用"
    t.integer "canvasapi_total_students", comment: "CANVAS合計学生数"
    t.string "canvasapi_image_download_url", limit: 2000, comment: "CANVASコースイメージダウンロードURL"
    t.string "image_download_url", limit: 2000, comment: "コースイメージダウンロードURL"
    t.string "canvasapi_time_zone", comment: "CANVASタイムゾーン"
    t.string "time_zone", comment: "タイムゾーン"
    t.boolean "canvasapi_blueprint", comment: "CANVAS Blueprintコース"
    t.boolean "blueprint", comment: "Blueprintコース"
    t.boolean "canvasapi_template", comment: "CANVASテンプレートコース"
    t.boolean "template", comment: "テンプレートコース"
    t.string "canvasapi_sis_import_id", comment: "CANVAS SISインポートID"
    t.string "canvasapi_sis_course_id", comment: "CANVAS SISコースID"
    t.string "sis_course_id", comment: "SISコースID"
    t.string "canvasapi_integration_id", comment: "CANVAS統合ID"
    t.string "integration_id", comment: "統合ID"
    t.integer "canvasapi_needs_grading_count", comment: "CANVAS未評価数"
    t.boolean "canvasapi_hide_final_grades", comment: "CANVAS最終成績非表示"
    t.boolean "hide_final_grades", comment: "最終成績非表示"
    t.text "canvasapi_public_description", comment: "CANVAS公開コース説明"
    t.text "public_description", comment: "公開コース説明"
    t.text "public_description_en", comment: "公開コース説明(英語)"
    t.string "canvasapi_workflow_state", comment: "CANVASワークフロー状態"
    t.string "canvasapi_course_format", comment: "CANVASコースフォーマット"
    t.string "course_format", comment: "コースフォーマット"
    t.boolean "canvasapi_restrict_enrollments_to_course_dates", comment: "CANVASコース日付制限"
    t.boolean "restrict_enrollments_to_course_dates", comment: "コース日付制限"
    t.boolean "update_lock", default: false, comment: "更新ロック"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "enrollment_dialog_user_ids_csv", comment: "履修者編集ダイアログで選択した canvas_users.id（CSV）"
    t.text "enrollment_dialog_rows_json", comment: "履修者編集ダイアログの行単位（user_id, section_id, role_id, enrollment_state）JSON配列"
    t.text "enrollment_dialog_by_admin_json", comment: "履修者編集ダイアログのドラフト（キー: admin_user.id の JSON オブジェクト）"
    t.string "status", comment: "ステータス"
    t.string "synced", comment: "同期ステータス"
    t.datetime "synced_at", comment: "同期ステータス日時"
    t.string "short_name", comment: "コース略称名（SIS Import用）"
    t.string "long_name", comment: "コース名（SIS Import用）"
    t.string "term_id", comment: "学期ID（SIS Import用）"
    t.string "course_id", comment: "コースID（SIS Import用）"
    t.boolean "blueprint_parent", comment: "ブループリント親コースフラグ"
    t.string "blueprint_key", comment: "ブループリント結合キー"
    t.string "workflow_state", comment: "ワークフロー状態"
    t.index ["deleted_at"], name: "index_canvas_courses_on_deleted_at"
  end

  create_table "canvas_enrollment_terms", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVAS履修学期", force: :cascade do |t|
    t.bigint "account_id", comment: "アカウントID"
    t.bigint "canvasapi_term_id", comment: "CANVAS学期ID"
    t.string "canvasapi_name", comment: "CANVAS学期名"
    t.string "name", comment: "学期名"
    t.datetime "canvasapi_start_at", comment: "CANVAS学期開始日時"
    t.datetime "start_at", comment: "学期開始日時"
    t.datetime "canvasapi_end_at", comment: "CANVAS学期終了日時"
    t.datetime "end_at", comment: "学期終了日時"
    t.string "canvasapi_workflow_state", comment: "CANVAS学期状態"
    t.bigint "canvasapi_grading_period_group_id", comment: "CANVAS成績期間グループID"
    t.datetime "canvasapi_created_at", comment: "CANVAS学期作成日時"
    t.string "canvasapi_sis_term_id", comment: "CANVAS SIS学期ID"
    t.string "sis_term_id", comment: "SIS学期ID"
    t.bigint "canvasapi_sis_import_id", comment: "CANVAS SISインポートID"
    t.boolean "update_lock", default: false, comment: "更新ロック"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["canvasapi_term_id"], name: "index_canvas_enrollment_terms_on_canvasapi_term_id", unique: true
    t.index ["deleted_at"], name: "index_canvas_enrollment_terms_on_deleted_at"
  end

  create_table "canvas_enrollments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVAS履修", force: :cascade do |t|
    t.bigint "canvasapi_enrollment_id", comment: "CANVAS履修ID"
    t.bigint "canvasapi_root_account_id", comment: "CANVASルートアカウントID"
    t.bigint "canvas_root_account_id", comment: "ルートアカウントID(連携)"
    t.bigint "root_account_id", comment: "ルートアカウントID"
    t.bigint "canvasapi_user_id", comment: "CANVASユーザID"
    t.bigint "canvas_user_id", comment: "ユーザID(連携)"
    t.bigint "user_id", comment: "ユーザID"
    t.bigint "canvasapi_course_id", comment: "CANVASコースID"
    t.bigint "canvas_course_id", comment: "コースID(連携)"
    t.bigint "course_id", comment: "コースID"
    t.bigint "canvasapi_section_id", comment: "CANVASセクションID"
    t.bigint "canvas_section_id", comment: "セクションID(連携)"
    t.bigint "section_id", comment: "セクションID"
    t.bigint "canvasapi_associated_user_id", comment: "CANVAS関連ユーザID"
    t.bigint "canvas_associated_user_id", comment: "関連ユーザID(連携)"
    t.bigint "associated_user_id", comment: "関連ユーザID"
    t.bigint "canvasapi_temporary_enrollment_source_user_id", comment: "CANVAS一時的な履修元ユーザID"
    t.bigint "canvas_temporary_enrollment_source_user_id", comment: "一時的な履修元ユーザID(連携)"
    t.bigint "temporary_enrollment_source_user_id", comment: "一時的な履修元ユーザID"
    t.bigint "canvasapi_temporary_enrollment_pairing_id", comment: "CANVAS一時的な履修ペアリングID"
    t.bigint "canvas_temporary_enrollment_pairing_id", comment: "一時的な履修ペアリングID(連携)"
    t.bigint "temporary_enrollment_pairing_id", comment: "一時的な履修ペアリングID"
    t.boolean "canvasapi_limit_privileges_to_course_section", comment: "CANVASコースセクションのみ権限制限"
    t.datetime "canvasapi_created_at", comment: "CANVAS作成日時"
    t.datetime "canvasapi_updated_at", comment: "CANVAS更新日時"
    t.datetime "canvasapi_start_at", comment: "CANVAS開始日時"
    t.datetime "canvasapi_end_at", comment: "CANVAS終了日時"
    t.string "canvasapi_type", comment: "CANVASタイプ"
    t.string "canvasapi_enrollment_state", comment: "CANVAS履修状態"
    t.string "enrollment_state", comment: "履修状態"
    t.string "canvasapi_role", comment: "CANVASロール"
    t.bigint "canvasapi_role_id", comment: "CANVASロールID"
    t.bigint "canvas_role_id", comment: "ロールID(連携)"
    t.bigint "role_id", comment: "ロールID"
    t.datetime "canvasapi_last_activity_at", comment: "CANVAS最後のアクティビティ日時"
    t.datetime "canvasapi_last_attended_at", comment: "CANVAS最後の出席日時"
    t.bigint "canvasapi_total_activity_time", comment: "CANVAS合計アクティビティ時間"
    t.bigint "canvasapi_sis_import_id", comment: "CANVAS SISインポートID"
    t.string "canvasapi_grades_html_url", comment: "CANVAS成績HTML URL"
    t.string "canvasapi_grades_current_grade", comment: "CANVA現在の評価文字"
    t.decimal "canvasapi_grades_current_score", precision: 10, comment: "CANVA現在の評点"
    t.string "canvasapi_grades_final_grade", comment: "CANVA最終の評価文字"
    t.decimal "canvasapi_grades_final_score", precision: 10, comment: "CANVA最終の評点"
    t.string "canvasapi_grades_unposted_current_grade", comment: "CANVA未通知の評価文字"
    t.decimal "canvasapi_grades_unposted_current_score", precision: 10, comment: "CANVA未通知の評点"
    t.string "canvasapi_grades_unposted_final_grade", comment: "CANVA未通知の最終評価文字"
    t.decimal "canvasapi_grades_unposted_final_score", precision: 10, comment: "CANVA未通知の最終評点"
    t.string "canvasapi_sis_account_id", comment: "CANVAS SISアカウントID"
    t.string "canvasapi_sis_course_id", comment: "CANVAS SISコースID"
    t.bigint "canvasapi_course_integration_id", comment: "CANVASコース統合ID"
    t.string "canvasapi_sis_section_id", comment: "CANVAS SISセクションID"
    t.string "canvasapi_section_integration_id", comment: "CANVASセクション統合ID"
    t.bigint "canvasapi_sis_user_id", comment: "CANVAS SISユーザID"
    t.string "canvasapi_html_url", comment: "CANVAS HTML URL"
    t.boolean "update_lock", default: false, comment: "更新ロック"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", comment: "ステータス"
    t.string "synced", comment: "同期ステータス"
    t.datetime "synced_at", comment: "同期ステータス日時"
    t.index ["associated_user_id"], name: "index_canvas_enrollments_on_associated_user_id"
    t.index ["canvas_associated_user_id"], name: "index_canvas_enrollments_on_canvas_associated_user_id"
    t.index ["canvas_course_id"], name: "index_canvas_enrollments_on_canvas_course_id"
    t.index ["canvas_root_account_id"], name: "index_canvas_enrollments_on_canvas_root_account_id"
    t.index ["canvas_section_id"], name: "index_canvas_enrollments_on_canvas_section_id"
    t.index ["canvas_temporary_enrollment_source_user_id"], name: "index_canvas_enrolls_on_canvas_temp_enroll_source_cuid"
    t.index ["canvas_user_id"], name: "index_canvas_enrollments_on_canvas_user_id"
    t.index ["canvasapi_associated_user_id"], name: "index_canvas_enrollments_on_canvasapi_associated_user_id"
    t.index ["canvasapi_course_id"], name: "index_canvas_enrollments_on_canvasapi_course_id"
    t.index ["canvasapi_enrollment_id"], name: "index_canvas_enrollments_on_canvasapi_enrollment_id", unique: true
    t.index ["canvasapi_section_id"], name: "index_canvas_enrollments_on_canvasapi_section_id"
    t.index ["canvasapi_temporary_enrollment_source_user_id"], name: "index_canvasapi_enrolls_on_canvas_temp_enroll_source_uid"
    t.index ["canvasapi_user_id"], name: "index_canvas_enrollments_on_canvasapi_user_id"
    t.index ["course_id"], name: "index_canvas_enrollments_on_course_id"
    t.index ["deleted_at"], name: "index_canvas_enrollments_on_deleted_at"
    t.index ["root_account_id"], name: "index_canvas_enrollments_on_root_account_id"
    t.index ["section_id"], name: "index_canvas_enrollments_on_section_id"
    t.index ["temporary_enrollment_source_user_id"], name: "index_canvas_enrolls_on_canvas_temp_enroll_source_uid"
    t.index ["user_id"], name: "index_canvas_enrollments_on_user_id"
  end

  create_table "canvas_integration_request_attachment_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASインテグレーション添付ファイル項目", force: :cascade do |t|
    t.bigint "integration_request_attachment_id", comment: "CANVASインテグレーション添付ファイルID"
    t.integer "column_number", comment: "項目番号"
    t.string "column_name", comment: "項目名"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_integration_request_attachment_fields_on_deleted_at"
    t.index ["integration_request_attachment_id"], name: "index_canvas_ira_fields_on_canvas_ira_id"
  end

  create_table "canvas_integration_request_attachment_values", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASインテグレーション添付セル値", force: :cascade do |t|
    t.bigint "integration_request_attachment_field_id", null: false, comment: "CANVASインテグレーション添付項目ID"
    t.integer "row_number", null: false, comment: "元 Excel の行番号（1 始まり、ヘッダーは 1）"
    t.text "cell_value", comment: "セル値"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_integration_request_attachment_values_on_deleted_at"
    t.index ["integration_request_attachment_field_id", "row_number"], name: "index_canvas_ir_av_on_field_id_and_row_number"
    t.index ["integration_request_attachment_field_id"], name: "index_canvas_ir_attachment_values_on_field_id"
  end

  create_table "canvas_integration_request_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASインテグレーション要求添付ファイル", force: :cascade do |t|
    t.bigint "integration_request_id", comment: "CANVASインテグレーション要求ID"
    t.string "type_div"
    t.string "filename"
    t.integer "file_size"
    t.string "document"
    t.string "token"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_type", comment: "ファイルタイプ"
    t.index ["deleted_at"], name: "index_canvas_integration_request_attachments_on_deleted_at"
    t.index ["integration_request_id"], name: "index_canvas_ir_attachments_on_canvas_ir_id"
  end

  create_table "canvas_integration_request_conditions", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASインテグレーション条件", force: :cascade do |t|
    t.bigint "integration_request_id", comment: "CANVASインテグレーション要求ID"
    t.string "integration_type", comment: "インテグレーションタイプ"
    t.string "condition_div", comment: "条件区分"
    t.string "and_or", comment: "AND/OR"
    t.integer "with_in_time", comment: "条件時間"
    t.string "time_div", comment: "単位"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_integration_request_conditions_on_deleted_at"
  end

  create_table "canvas_integration_requests", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASインテグレーション要求", force: :cascade do |t|
    t.bigint "job_manage_id", comment: "ジョブ管理ID"
    t.string "integration_type", comment: "インテグレーションタイプ"
    t.bigint "account_id", comment: "対象サブアカウント（canvas_accounts.id）"
    t.boolean "run_immediately", comment: "即時実行フラグ"
    t.string "cron_expression", comment: "定期実行クーロン表現"
    t.string "import_dir_path", comment: "インポートディレクトリパス"
    t.string "filename", comment: "ファイル名"
    t.boolean "filename_regex", comment: "ファイル名正規表現"
    t.bigint "parent_canvas_integration_request_id", comment: "親インテグレーション要求ID"
    t.string "run_day", comment: "毎月N日に実行"
    t.boolean "run_sunday", comment: "日曜日実行フラグ"
    t.boolean "run_monday", comment: "月曜日実行フラグ"
    t.boolean "run_tuesday", comment: "火曜日実行フラグ"
    t.boolean "run_wednesday", comment: "水曜日実行フラグ"
    t.boolean "run_thursday", comment: "木曜日実行フラグ"
    t.boolean "run_friday", comment: "金曜日実行フラグ"
    t.boolean "run_saturday", comment: "土曜日実行フラグ"
    t.boolean "run_without_saturday", comment: "実行日が土曜日の場合は、翌日に実行"
    t.boolean "run_without_sunday", comment: "実行日が日曜日の場合は、翌日に実行"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "input_rows", comment: "入力行数"
    t.integer "success_rows", comment: "成功行数"
    t.integer "error_rows", comment: "エラー行数"
    t.integer "skipped_rows", comment: "同値のためSIS未出力行数"
    t.index ["account_id"], name: "index_canvas_integration_requests_on_account_id"
    t.index ["deleted_at"], name: "index_canvas_integration_requests_on_deleted_at"
    t.index ["job_manage_id"], name: "index_canvas_integration_requests_on_job_manage_id"
  end

  create_table "canvas_role_accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASロールアカウント", force: :cascade do |t|
    t.bigint "role_id", comment: "CANVASロールID"
    t.bigint "account_id", comment: "CANVASアカウントID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_canvas_role_accounts_on_account_id"
    t.index ["deleted_at"], name: "index_canvas_role_accounts_on_deleted_at"
    t.index ["role_id"], name: "index_canvas_role_accounts_on_role_id"
  end

  create_table "canvas_role_permissions", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASロールパーミッション", force: :cascade do |t|
    t.bigint "role_id", comment: "CANVASロールID"
    t.string "canvasapi_permission_name", comment: "CANVASロールパーミッション名"
    t.boolean "canvasapi_enabled", comment: "CANVASロールパーミッション有効フラグ"
    t.boolean "enabled", comment: "ロールパーミッション有効フラグ"
    t.boolean "canvasapi_locked", comment: "CANVASロールパーミッションロックフラグ"
    t.boolean "locked", comment: "ロールパーミッションロックフラグ"
    t.boolean "canvasapi_readonly", comment: "CANVASロールパーミッション読み取り専用フラグ"
    t.boolean "local_readonly", comment: "ロールパーミッション読み取り専用フラグ"
    t.boolean "canvasapi_explicit", comment: "CANVASロールパーミッション明示フラグ"
    t.boolean "explicit", comment: "ロールパーミッション明示フラグ"
    t.boolean "canvasapi_prior_default", comment: "CANVASロールパーミッション前のデフォルトフラグ"
    t.boolean "prior_default", comment: "ロールパーミッション前のデフォルトフラグ"
    t.string "canvasapi_group", comment: "CANVASロールパーミッショングループ"
    t.string "local_group", comment: "ロールパーミッショングループ"
    t.boolean "canvasapi_applies_to_self", comment: "CANVASロールパーミッション自身のみフラグ"
    t.boolean "applies_to_self", comment: "ロールパーミッション自身のみフラグ"
    t.boolean "canvasapi_applies_to_descendants", comment: "CANVASロールパーミッション子ロールのみフラグ"
    t.boolean "applies_to_descendants", comment: "ロールパーミッション子ロールのみフラグ"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_role_permissions_on_deleted_at"
    t.index ["role_id"], name: "index_canvas_role_permissions_on_role_id"
  end

  create_table "canvas_roles", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASロール", force: :cascade do |t|
    t.bigint "canvasapi_role_id", comment: "CANVASロールID"
    t.string "canvasapi_role", comment: "CANVASロール名"
    t.string "canvasapi_label", comment: "CANVAS表示名"
    t.string "label", comment: "表示名"
    t.string "canvasapi_base_role_type", comment: "CANVASベースロール種別"
    t.string "base_role_type", comment: "ベースロール種別"
    t.bigint "canvas_parent_role_id", comment: "親CANVASロールID"
    t.bigint "parent_role_id", comment: "親ロールID"
    t.string "canvasapi_workflow_state", comment: "CANVASロール状態"
    t.datetime "canvasapi_created_at", comment: "CANVASロール作成日時"
    t.datetime "canvasapi_last_updated_at", comment: "CANVASロール更新日時"
    t.boolean "canvasapi_is_account_role", comment: "CANVASアカウントロール"
    t.boolean "update_lock", default: false, comment: "更新ロック"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["canvasapi_role_id"], name: "index_canvas_roles_on_canvasapi_role_id"
    t.index ["deleted_at"], name: "index_canvas_roles_on_deleted_at"
  end

  create_table "canvas_sections", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASセクション", force: :cascade do |t|
    t.bigint "canvasapi_section_id", comment: "CANVASセクションID"
    t.string "canvasapi_section_name", comment: "CANVASセクション名"
    t.bigint "canvasapi_course_id", comment: "CANVASコースID"
    t.bigint "canvas_course_id", comment: "CANVASコースID(連携)"
    t.bigint "course_id", comment: "CANVASコースID"
    t.bigint "canvasapi_nonxlist_course_id", comment: "CANVAS非リストコースID"
    t.datetime "canvasapi_start_at", comment: "CANVASセクション開始日時"
    t.datetime "canvasapi_end_at", comment: "CANVASセクション終了日時"
    t.boolean "canvasapi_restrict_enrollments_to_section_dates", comment: "CANVASセクション日付制限"
    t.datetime "canvasapi_created_at", comment: "CANVASセクション作成日時"
    t.string "canvasapi_sis_section_id", comment: "CANVAS SISセクションID"
    t.string "canvasapi_sis_course_id", comment: "CANVAS SISコースID"
    t.string "canvasapi_integration_id", comment: "CANVAS統合ID"
    t.bigint "canvasapi_sis_import_id", comment: "CANVAS SISインポートID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["canvas_course_id"], name: "index_canvas_sections_on_canvas_course_id"
    t.index ["canvasapi_course_id"], name: "index_canvas_sections_on_canvasapi_course_id"
    t.index ["canvasapi_section_id"], name: "index_canvas_sections_on_canvasapi_section_id", unique: true
    t.index ["deleted_at"], name: "index_canvas_sections_on_deleted_at"
  end

  create_table "canvas_usages", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CanvasAdmin利用ガイド", force: :cascade do |t|
    t.text "message", comment: "利用ガイドメッセージ"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_usages_on_deleted_at"
  end

  create_table "canvas_user_accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASユーザ_アカウント", force: :cascade do |t|
    t.bigint "user_id", comment: "CANVASユーザID"
    t.bigint "account_id", comment: "CANVASアカウントID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_user_accounts_on_deleted_at"
  end

  create_table "canvas_user_custom_fields", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASユーザのカスタムフィールド", force: :cascade do |t|
    t.integer "user_id", comment: "CANVASユーザID"
    t.integer "custom_field_id", comment: "カスタムフィールドID"
    t.string "field_value", comment: "カスタムフィールド値"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_canvas_user_custom_fields_on_custom_field_id"
    t.index ["deleted_at"], name: "index_canvas_user_custom_fields_on_deleted_at"
    t.index ["user_id"], name: "index_canvas_user_custom_fields_on_user_id"
  end

  create_table "canvas_user_linkages", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASユーザ名寄せ", force: :cascade do |t|
    t.bigint "source_canvas_user_id", comment: "名寄せ元CANVASユーザID"
    t.bigint "target_canvas_user_id", comment: "名寄せ先CANVASユーザID"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_canvas_user_linkages_on_deleted_at"
  end

  create_table "canvas_users", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "CANVASユーザ", force: :cascade do |t|
    t.bigint "canvasapi_user_id", comment: "CANVASユーザID"
    t.string "canvasapi_name", comment: "CANVASユーザ名"
    t.string "name", comment: "ユーザ名"
    t.string "name_en", comment: "ユーザ名(英語)"
    t.datetime "canvasapi_created_at", comment: "CANVASユーザ作成日時"
    t.string "canvasapi_sortable_name", comment: "CANVASユーザソート名"
    t.string "sortable_name", comment: "ユーザソート名"
    t.string "sortable_name_en", comment: "ユーザソート名(英語)"
    t.string "canvasapi_short_name", comment: "CANVASユーザ略称"
    t.string "short_name", comment: "ユーザ略称"
    t.string "canvasapi_sis_user_id", comment: "CANVAS SISユーザID"
    t.string "sis_user_id", comment: "SISユーザID"
    t.string "canvasapi_integration_id", comment: "CANVAS連携ID"
    t.string "integration_id", comment: "連携ID"
    t.bigint "canvasapi_sis_import_id", comment: "CANVAS SISインポートID"
    t.string "canvasapi_login_id", comment: "CANVASログインID"
    t.string "login_id", comment: "ログインID"
    t.string "canvasapi_avatar_url", limit: 2000, comment: "CANVASアバターURL"
    t.string "avatar_url", limit: 2000, comment: "アバターURL"
    t.string "canvasapi_last_name"
    t.string "last_name"
    t.string "last_name_en"
    t.string "canvasapi_first_name", comment: "CANVAS名"
    t.string "first_name", comment: "名"
    t.string "first_name_en", comment: "CANVAS名(英語)"
    t.string "canvasapi_email", comment: "CANVASメールアドレス"
    t.string "email", comment: "メールアドレス"
    t.string "canvasapi_locale", comment: "CANVASロケール"
    t.string "canvasapi_effective_locale", comment: "CANVAS有効ロケール"
    t.string "effective_locale", comment: "有効ロケール"
    t.string "canvasapi_uuid", comment: "UUID"
    t.datetime "canvasapi_last_login", comment: "CANVAS最終ログイン日時"
    t.boolean "update_lock", default: false, comment: "更新ロック"
    t.bigint "creator_id", comment: "作成ユーザID"
    t.bigint "updater_id", comment: "更新ユーザID"
    t.bigint "deleter_id", comment: "削除ユーザID"
    t.datetime "deleted_at", comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", comment: "ステータス"
    t.string "synced", comment: "同期ステータス"
    t.datetime "synced_at", comment: "同期ステータス日時"
    t.index ["canvasapi_user_id"], name: "index_canvas_users_on_canvasapi_user_id", unique: true
    t.index ["deleted_at"], name: "index_canvas_users_on_deleted_at"
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
    t.index ["deleted_at"], name: "index_lti_operation_logs_on_deleted_at"
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
