class CreateJobManageErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :job_manage_errors, comment: "JOB管理エラー" do |t|
      t.bigint :job_manage_id, comment: "JOB管理ID"
      t.string :message, comment: "エラーメッセージ"
      t.integer :row_no, comment: "行番号"
      t.string :target_name, comment: "対象名"
      t.bigint "creator_id", comment: "作成ユーザID"
      t.bigint "updater_id", comment: "更新ユーザID"
      t.bigint "deleter_id", comment: "削除ユーザID"
      t.datetime :deleted_at, index: true, comment: "削除日時"
      t.timestamps
    end
  end
end
