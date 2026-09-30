module SystemSettings
  class SearchConditions
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
    include ActiveModel::Model
    attr_accessor :sites, :setting_div, :setting_category_div
    attr_accessor :current_admin_user
    def search
      system_settings = SystemSetting.joins(:system_setting_sites)
      admin_user_sites = self.sites.to_a.empty? ? Site.active.where(id: self.current_admin_user.sites.map(&:id)).all.to_a : self.sites
      system_settings = system_settings.where("system_setting_sites.site_id in (?)", admin_user_sites)
      system_settings = system_settings.where(:"system_settings.setting_div" => self.setting_div) unless self.setting_div.blank?
      system_settings = system_settings.where(:"system_settings.setting_category_div" => self.setting_category_div) unless self.setting_category_div.blank?
      system_settings = system_settings.order("setting_category_div, setting_div")
      return system_settings.order(:setting_div) #.uniq(:"system_setting_sites.site_id")
    end

  end
    
end