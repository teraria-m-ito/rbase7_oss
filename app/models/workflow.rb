class Workflow < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base
  
  has_many :workflow_sites, dependent: :destroy, autosave: true
  has_many :sites, :through => :workflow_sites
  has_many :state_flows
  has_many :workflow_states, ->{order("display_order")}, dependent: :destroy
  
  belongs_to :issue_type, optional: true
  
  validates :workflow_name, presence: true

  validates :issue_type_id, presence: true

  accepts_nested_attributes_for :workflow_states,  :allow_destroy => true
  accepts_nested_attributes_for :workflow_sites,  :allow_destroy => true

  validates :site_ids, presence: true

  attr_accessor :temp_site_ids

  validates :site_ids, presence: true
  
  scope :user_prohabbits, ->(site_ids) { joins(:workflow_sites).where("workflow_sites.site_id in (?)", site_ids).select("DISTINCT workflows.*")}

  def deletable?
    self.deletable
  end
  
  def temp_sites
    Site.where("id in (?)", site_ids)
  end
  
  # def self.user_prohabbits(admin_user)
    # Workflow.joins(:workflow_sites).where("workflow_sites.site_id in (?)", admin_user.site_ids).all
  # end
end
