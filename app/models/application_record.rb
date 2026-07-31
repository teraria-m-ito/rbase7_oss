class ApplicationRecord < ActiveRecord::Base
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ApplicationConcern
  acts_as_paranoid
  primary_abstract_class

  attr_accessor :current_admin_user
  attr_accessor :current_site_id

  connects_to database: { writing: :primary, reading: :primary}

  def assign_attributes_except_save(new_attributes)
    ActiveRecord::Base.transaction do
      assign_attributes(new_attributes)
      raise ActiveRecord::Rollback
    end
  end

  def created_userstamp
    ::Rails.logger.debug("created_userstamp class:#{self.class.name}")
    self.current_admin_user = get_current_admin_user if self.current_admin_user.nil?
    return if self.current_admin_user.nil?

    self.creator_id = self.current_admin_user.id
    self.updater_id = self.current_admin_user.id
  end

  def updated_userstamp
    ::Rails.logger.debug("updated_userstamp class:#{self.class.name}")
    self.current_admin_user = get_current_admin_user if self.current_admin_user.nil?
    return if self.current_admin_user.nil?

    self.updater_id = self.current_admin_user.id
  end

  def destroyed_userstamp
    ::Rails.logger.debug("destroyed_userstamp class:#{self.class.name}")
    self.current_admin_user = get_current_admin_user if self.current_admin_user.nil?
    self
  end
end
