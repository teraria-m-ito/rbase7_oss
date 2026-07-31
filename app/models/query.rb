class Query < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  belongs_to :admin_user, optional: true
  
  validates :title, presence: true
  validates :target_class, presence: true
  validates :query_content, presence: true
  validates :admin_user_id, presence: true
  
  scope :targets, ->(target) { where("target_class = ?", target) }
  scope :shares, ->(target_class) { where("target_class = ? and shared =  ?", target_class, true)}
  scope :owns, ->(user_id, target_class){ where("admin_user_id = ? and target_class = ?", user_id, target_class) }
  scope :owns_and_shares, ->(user_id){ where("admin_user_id = ? or shared = true", user_id) }
end
