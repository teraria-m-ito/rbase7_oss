class MailTemplate < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base
  
  has_many :mail_template_sites, dependent: :destroy, autosave: true
  has_many :sites, :through => :mail_template_sites

  scope :for_site, ->(site_id) { joins(:mail_template_sites).where("mail_template_sites.site_id = ?", site_id) }
  
  validates :template_div, presence: true
  validates :template_name, presence: true
  validates :from_address, presence: true
  validates :to_address, presence: true
  validates :subject, presence: true
  validates :body, presence: true
  validates :site_ids, presence: true

  selectable_attr :template_div do
    entry '01', :created, 'When created'
    entry '02', :updated, 'When updated'
    entry '09', :finished, 'When finished'
  end

  selectable_attr :from_address do
    entry '01', :issue_creator, 'Issue creator'
    entry '02', :issue_updater, 'Issue updater'
    entry '03', :issue_assigned, 'Issue assigned'
    entry '09', :system_setting, 'System setting'
  end

  selectable_attr :to_address do
    entry '00', :all_member, 'All members'
    entry '01', :issue_creator, 'Issue creator'
    entry '02', :issue_updater, 'Issue updater'
    entry '04', :issue_assigned, 'Issue assigned'
    entry '05', :issue_creator_and_assigned, 'Issue creator & assigned'
    entry '09', :system_setting, 'System setting'
  end

  selectable_attr :enable do
    entry nil, :nil, "不許可"
    entry false, :false, "不許可"
    entry true, :true, "許可"
  end
end
