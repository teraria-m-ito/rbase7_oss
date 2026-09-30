class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  attr_accessor :current_admin_user

  def self.perform(*args, site_id: nil)
    if site_id.present?
      id = site_id.to_i
      site_id = (id > 0 && Site.active.exists?(id)) ? id : nil
    else
      site_id = Thread.current[:request].try(:session).try(:[], :active_site_id)
      site_id = site_id.to_i
      site_id = nil unless site_id > 0 && Site.active.exists?(site_id)
      if site_id.blank? && Site.active.count == 1
        site_id = Site.active.limit(1).pick(:id)
      end
    end

    timing = site_id.present? ? SystemSetting.get_setting(:delayed_job_timing, site_id) : nil
    if timing == "1" && ENV['RAILS_ENV'] == 'production'
      self.perform_later(*args)
    else
      self.perform_now(*args)
    end
  end
  def self.debug_log(message)
    Rails.logger.info(message)
    puts message
  end
end
