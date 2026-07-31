module ApplicationConcern
  extend ActiveSupport::Concern

  class_methods do
    def get_current_lms_user
      req = Thread.current[:request]
      return nil unless req&.session

      req.session[:current_lms_user]
    end

    def get_current_admin_user
      lms = get_current_lms_user
      if lms&.respond_to?(:admin_user) && lms.admin_user
        return lms.admin_user
      end

      # devise_for :admin_users → Warden スコープは :admin_user（LmsUser が無いローカルログイン等）
      req = Thread.current[:request]
      return nil unless req

      warden = req.env["warden"]
      return nil unless warden

      warden.user(:admin_user)
    end

    def get_current_site_id
      req = Thread.current[:request]
      return nil unless req&.session

      req.session[:active_site_id]
    end

    def logging_task_log(message)
      ::Rails.logger.info(message)
      puts(message)
    end

    def logging_task_debuglog(message)
      ::Rails.logger.debug(message)
      puts(message)
    end
  end

  def get_current_lms_user
    self.class.get_current_lms_user
  end

  def get_current_admin_user
    self.class.get_current_admin_user
  end

  def get_current_site_id
    self.class.get_current_site_id
  end
end
