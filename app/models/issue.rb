class Issue < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base
  include CustomFieldDynamicAccessors

  stampable

  after_find :set_limited_at
  before_save :set_prev_workflow_state

  belongs_to :site, optional: true
  belongs_to :workflow_state, optional: true

  belongs_to :issue_type, optional: true

  belongs_to :assigned, class_name: "::AdminUser", foreign_key: "assigned_id", optional: true
  belongs_to :issuer, class_name: "::AdminUser", foreign_key: "issued_id", optional: true
  
  has_many :issue_custom_fields, dependent: :destroy, autosave: true, inverse_of: :issue
  has_many :custom_fields,
           -> { order('custom_fields.display_order ASC') },
           :through => :issue_custom_fields
    
  accepts_nested_attributes_for :issue_custom_fields, reject_if: :all_blank
  has_many :custom_fields, :through => :issue_custom_fields

  custom_field_dynamic_accessors!(
    association: :issue_custom_fields,
    data_source: :issue_custom_fields,
    custom_field_scope: lambda {
      if ::CustomField.respond_to?(:issues)
        ::CustomField.issues
      else
        ::CustomField.where(custom_field_type: "issue").order(:display_order)
      end
    }
  )

  belongs_to :prev_workflow_state, class_name: "::WorkflowState", foreign_key: "prev_workflow_state_id", optional: true
  belongs_to :current_workflow_state, class_name: "::WorkflowState", foreign_key: "workflow_state_id", optional: true

  validates :title, presence: true
  validates :issue_type_id, presence: true
  validates :workflow_state_id, presence: true

  attr_accessor :current_admin_user
  attr_accessor :creator_name
  attr_accessor :updater_name
  
  attr_accessor :next_workflow_state
  
  attr_accessor :target_instance

  attr_accessor :bundle_no
  
  default_scope ->{ order('updated_at desc') }  
#  default_desc_scope ->{ order('created_at desc') }  
  
  selectable_attr :priority do
    entry 'asap', :asap, 'As soon as posible'
    entry 'high', :high, 'High'
    entry 'normal', :normal, 'Normal'
    entry 'low', :low, 'Low'
  end
  
  def state_cd
    WorkflowState.find(self.workflow_state_id).state_cd
  end  
  
  def state_name
    WorkflowState.find(self.workflow_state_id).state_name
  end
  
  def aviable_workflow_states(admin_user)
    target_ids = [self.workflow_state_id]
    state_flow_workflow_states = self.issue_type.present? ? StateFlow.where(workflow_id: self.issue_type.workflow.id).where(role_id: admin_user.role_id).first.state_flow_workflow_states : []
    state_flow_workflow_states.each do |state_flow_workflow_state|
      target_ids << state_flow_workflow_state.next_workflow_state_id if state_flow_workflow_state.current_workflow_state_id == self.workflow_state_id
    end
    WorkflowState.where(id: target_ids.uniq).order(:display_order)
  end
    
  def invoke (state_cd = nil)
    logic = get_logic
    logic.role = self.assigned.try(:role)
    if state_cd
      logic.invoke(state_cd)
    else
      logic.update_status(@prev_workflow_state, @current_workflow_state)
    end
  end

  def next_status(next_status_cd = nil)
    logic = get_logic
    logic.role = self.assigned.try(:role)
    logic.next_state(@prev_workflow_state, @current_workflow_state, next_status_cd)
  end

  def issue_from_adddresses(mail_template)
    targets = []
    case mail_template.from_address_key
    when :issue_creator
      targets << AdminUser.where(id: self.creator_id).first.email
    when :issue_updater
      targets << AdminUser.where(id: self.updater_id).first.email
    when :issue_assigned
      targets << AdminUser.where(id: self.issued_id).first.email unless issue.issued_id
    when :system_setting
    end
    targets
  end

  def issue_to_adddresses(mail_template)
    targets = []
    case mail_template.to_address_key
    when :all_member
      admin_useres = AdminUser.joins(:admin_user_sites).where("admin_user_sites.site_id = ?", self.site_id).all
      targets += admin_useres.map(&:email)
    when :issue_creator
      targets << AdminUser.where(id: self.creator_id).email
    when :issue_updater
      targets << AdminUser.where(id: self.updater_id).email
    when :issue_assigned
      targets << AdminUser.where(id: self.issued_id).email unless issue.issued_id
    when :issue_creator_and_assigned
      targets << AdminUser.where(id: self.creator_id).email
      targets << AdminUser.where(id: self.issued_id).email unless issue.issued_id
    when :system_setting
    end
    targets
  end
  
  def prev_workflow_state
    WorkflowState.find(self.prev_workflow_state_id)
  end

  def creator_name
    ::AdminUser.where(id: self.creator_id).first.try(:name)
  end
  
  def updater_name
    ::AdminUser.where(id: self.updater_id).first.try(:name)
  end

  def change_deleted_state
    change_deleted_state_result = false
    deleted_workflow_state = nil
    role_id = self.current_admin_user.role.id
    self.workflow_state.state_flow_workflow_states.joins(:state_flow).where(state_flows: {role_id: role_id}).each do |state_flow_workflow_state|
      next_workflow_states = state_flow_workflow_state.next_workflow_state
      deleted_workflow_state = state_flow_workflow_state.next_workflow_state.where("workflow_states.deleted_state = ?", true).first
      unless deleted_workflow_state.nil?
        break
      end
    end
    unless deleted_workflow_state.nil?
      self.prev_workflow_state_id = self.workflow_state_id
      self.workflow_state_id = deleted_workflow_state.id
      change_deleted_state_result = true
    end
    self.save!
    change_deleted_state_result
  end

  private
  
  def get_logic
    logic_name = self.issue_type.issue_type_class
    @prev_workflow_state = WorkflowState.where(id: self.prev_workflow_state_id).first #初回時はnilが有り得る
    @current_workflow_state = WorkflowState.find(self.workflow_state_id)
    logic = eval("::Logic::#{logic_name.classify}.new(self)")
    logic
  end

  def set_limited_at
    self.limited_at = self.limited_at.strftime('%Y/%m/%d') unless self.limited_at.blank?
  end

  def set_prev_workflow_state
    self.prev_workflow_state_id = self.workflow_state_id_was if self.workflow_state_id_was != self.workflow_state_id
  end
  
  
  def set_creator
    self.creator_id = self.current_admin_user.id
  end
  def set_updater
    self.updater_id = self.current_admin_user.id
  end
  def set_deleter
    self.deleter_id = self.current_admin_user.id
  end
end
