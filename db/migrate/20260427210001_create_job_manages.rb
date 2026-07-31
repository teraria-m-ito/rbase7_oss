class CreateJobManages < ActiveRecord::Migration[7.0]
  def change
    create_table :job_manages, comment: "ジョブ管理" do |t|
      t.string :active_job_id, index: true, comment: "ジョブID"
      t.string :job_type, comment: "ジョブタイプ"
      t.string :status, comment: "ステータス"
      t.bigint :request_by, comment: "要求者ID"
      t.datetime :requested_at, comment: "要求日時"
      t.datetime :started_at, comment: "開始日時"
      t.datetime :finished_at, comment: "終了日時"
      t.integer :spent, comment: "経過時間"
      t.bigint "creator_id", comment: "作成ユーザID"
      t.bigint "updater_id", comment: "更新ユーザID"
      t.bigint "deleter_id", comment: "削除ユーザID"
      t.datetime :deleted_at, index: true, comment: "削除日時"
      t.timestamps
    end
  end
end
