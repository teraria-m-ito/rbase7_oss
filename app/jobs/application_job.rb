class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  attr_accessor :current_admin_user

  def self.perform(*args)
    timing = SystemSetting[:delayed_job_timing, Site.first.id]
    if timing and ENV['RAILS_ENV'] == 'production'
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
