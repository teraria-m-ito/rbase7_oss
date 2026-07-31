module AdminUsers
  class SearchConditions
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    include ActiveModel::Model
    include ::SelectableAttr::Base

    attr_accessor :site_id
    attr_accessor :current_admin_user
    attr_accessor :name
    attr_accessor :email

    def search
      admin_users = ::AdminUser.all
      self.site_id.delete_if{|x| x.blank?} if self.site_id.present?

      if self.site_id.present?
        admin_users = admin_users.joins(:admin_user_sites).where("admin_user_sites.site_id IN (?)", self.site_id)
      else
        admin_users = admin_users.joins(:admin_user_sites).where("admin_user_sites.site_id IN (?)", current_admin_user.site_ids)
      end
      admin_users = admin_users.where("name like ?", "#{self.name}%") unless self.name.blank?
      admin_users = admin_users.where("email like ?", "#{self.email}%") unless self.email.blank?

      admin_users = admin_users.distinct
      admin_users = admin_users.order("updated_at asc")
      admin_users
    end
  end
end
