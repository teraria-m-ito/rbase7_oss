class Site < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base
  
  has_many :admin_user_sites
  has_many :admin_users, :through => :admin_user_sites

  has_many :issue_type_sites
  has_many :issue_type, :through => :issue_type_sites
  
  validates :site_name, presence: {message: I18n.t("activerecord.errors.messages.blank")}
  validates :status_div, presence: {message: I18n.t("activerecord.errors.messages.blank")}

  selectable_attr :status_div do
    entry 'before_apply', :before_apply, 'before_apply'
    entry 'applying', :applying, 'applying'
    entry 'accepted', :accepted, 'accepted'
    entry 'denied', :denied, 'denied'
  end
  
  scope :active, -> { where status_div: 'accepted'} 
  scope :accesable, ->(site_ids) { joins(:admin_user_sites).where("admin_user_sites.site_id IN (?)", site_ids) }
  scope :admin_user_accesable, ->(admin_user_id, site_ids) { joins(:admin_user_sites).where("admin_user_sites.site_id IN (?)", site_ids).where(:'admin_user_sites.admin_user_id' => admin_user_id) }
end
