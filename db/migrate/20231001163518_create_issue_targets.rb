class CreateIssueTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_targets, comment: "申請対象" do |t|
      t.integer :issue_id, index: true, comment: "申請ID"
      t.references :target, null: false, polymorphic: true
      t.datetime :deleted_at, index: true, comment: "削除日時"
      t.timestamps
    end
  end
end
