class IssueType < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  has_many :issue_type_sites, dependent: :destroy, autosave: true
  has_many :sites, :through => :issue_type_sites

  validates :issue_type_short_name, presence: true
  validates :issue_type_name, presence: true
  validates :issue_type_class, presence: true

  has_one :workflow
  has_many :workflow_states, through: :workflow do
    def start_points
      where("workflow_states.default_value = ?", true)
    end
    def end_points
      where("workflow_states.end_point = ?", true)
    end
  end

  selectable_attr :issue_type_class do
    update_by_array LogicData.all, when: :everytime
    entry 'base_logic', :base_logic, 'Base Logic'
  end
  
#  scope :issue_type_for_sites, ->(site_ids) {joins(:issue_type_sites).where("issue_type_sites.site_id IN (?)", site_ids)}

  validates :site_ids, presence: true

  def deletable?
    self.deletable
  end

  def self.issue_type_for_sites(site_ids)
    result = []
    return result if site_ids.empty?
    IssueType.all.each do |issue_type|
      found = true
      site_ids.each do |site_id|
        found = false unless issue_type.issue_type_sites.map(&:site_id).include?(site_id)
        break unless found
      end
      result << issue_type if found
    end
    result
  end
  
  def self.user_prohabbits(admin_user)
    result = []
    unless admin_user.site_ids.empty?
      IssueType.all.each do |issue_type|
        found = true
        admin_user.site_ids.each do |site_id|
          found = false unless issue_type.issue_type_sites.map(&:site_id).include?(site_id)
          break unless found
        end
        result << issue_type if found
      end
    end
    IssueType.where(id: result.map(&:id))
  end  
end
