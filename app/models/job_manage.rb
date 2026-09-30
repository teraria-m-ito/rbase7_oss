class JobManage < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  stampable

  belongs_to :request_by_user, class_name: "AdminUser", foreign_key: "request_by", optional: true

  has_many :job_manage_errors, dependent: :destroy

  selectable_attr :job_type do
    update_with_plugins(:JobManage, :added_entries_for_job_type)
  end

  def self.added_entries_for_job_type(mod); end

  selectable_attr :status do
    entry 'registered', :registered, '登録済'
    entry 'wait', :wait, '処理待ち'
    entry 'processing', :processing, '処理中'
    entry 'done', :done, '処理完了'
    entry 'error', :error, 'エラー'
  end

  selectable_attr :status_user do
    update_with_plugins(:JobManage, :added_entries_for_status_user)
  end

  def self.added_entries_for_status_user(mod); end

  def self.get_job_manage(job_type, job_manage_id)
    JobManage.where(id: job_manage_id, job_type: job_type).first
  end

  def self.register_job(job_type, current_admin_user)
    job_manage = JobManage.new
    job_manage.status = "registered"
    job_manage.status_message = status_name_by_key(:registered)
    job_manage.job_type = job_type
    job_manage.request_by = current_admin_user.id
    job_manage.save!
    job_manage
  end

  def start_wait_job(job)
    update!(
      active_job_id: job.job_id,
      status: "wait",
      status_message: self.class.status_name_by_key(:wait),
      requested_at: Time.now
    )
  end

  ##
  # 処理開始。status は常に processing とし、表示文言を status_message に保存する。
  # 例: start_job(status_user: :processing_etl) → status_message = "処理中（ETL実行中）"
  # started_at は初回のみ設定する（詳細ステータス更新時に上書きしない）。
  def start_job(status_user: nil)
    attrs = {
      status: "processing",
      status_message: processing_status_message(status_user)
    }
    attrs[:started_at] = Time.now if started_at.blank?
    update!(attrs)
  end

  def finished_job
    spent_sec = started_at.present? ? (Time.current - started_at).to_i : nil
    update!(
      status: "done",
      status_message: self.class.status_name_by_key(:done),
      finished_at: Time.current,
      spent: spent_sec
    )
  end

  def errored_job
    spent_sec = started_at.present? ? (Time.current - started_at).to_i : nil
    update!(
      status: "error",
      status_message: self.class.status_name_by_key(:error),
      finished_at: Time.current,
      spent: spent_sec
    )
  end

  ##
  # 画面には保存済みの status_message を優先して表示する。
  def status_name
    status_message.presence || self.class.status_name_by_id(status.to_s)
  end

  def processing_status_message(status_user)
    base = self.class.status_name_by_key(:processing).to_s
    return base if status_user.blank?

    detail = self.class.status_user_name_by_key(status_user).presence ||
             self.class.status_user_name_by_id(status_user.to_s).presence ||
             status_user.to_s
    "#{base}（#{detail}）"
  end
  private :processing_status_message

end
