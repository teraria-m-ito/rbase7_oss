class CustomField < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  has_many :custom_field_sites, dependent: :destroy, autosave: true
  has_many :sites, :through => :custom_field_sites

  attr_accessor :list_field, :date_field, :datetime_field

  validates :field_name, presence: true
  validates :display_name, presence: true
  validates :custom_field_type, presence: true
  validates :issue_type, presence: true, if: Proc.new {|p| p.custom_field_type_key == :issue}
  # validates :field_type, presence: true
  validates :field_size, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }, allow_nil: true
  validates :field_type, presence: true

  accepts_nested_attributes_for :custom_field_sites,  :allow_destroy => true

  validates :site_ids, presence: true

  scope :issues, -> { where(custom_field_type: 'issue').order(:display_order) }
  scope :issues_for_issue_type, ->(issue_type) { where(custom_field_type: 'issue').where("issue_type = ?", issue_type) }
  scope :admin_users, -> { where(custom_field_type: 'admin_user').order(:display_order) }
  
  selectable_attr :custom_field_type do
    entry 'admin_user', :admin_user, 'Admin User'
    entry 'issue', :issue, 'Issue'
    update_with_plugins(:CustomField, :added_entries_for_setting_custom_field_type)
  end

  def self.added_entries_for_setting_custom_field_type(mod); end

  selectable_attr :field_type do
    entry 'boolean', :boolean, 'Boolean', regexp: false, default_field: true, list_field: false, calendar: false, dt_calendar: false, time_field: false
    entry 'integer', :integer, 'Integer', regexp: true, default_field: true, list_field: false, calendar: false, dt_calendar: false, time_field: false
    entry 'string', :string, 'String', regexp: true, default_field: true, list_field: false, calendar: false, dt_calendar: false, time_field: false
    entry 'list', :list, 'List', regexp: false, default_field: false, list_field: true, calendar: false, dt_calendar: false, time_field: false
    entry 'date', :date, 'Date', regexp: false, default_field: false, list_field: false, calendar: true, dt_calendar: false, time_field: false
    entry 'date_time', :date_time, 'DateTime', regexp: false, default_field: false, list_field: false, calendar: false, dt_calendar: true, time_field: false
    update_with_plugins(:CustomField, :added_entries_for_setting_field_type)
  end

  def self.added_entries_for_setting_field_type(mod); end

  def cleansing
    self.issue_type = nil unless self.custom_field_type_key == :issue
    field_type_entry = CustomField.field_type_entry_by_key(self.field_type_key)
    self.format_regexp = nil unless field_type_entry[:regexp]
    self.list_field = nil unless field_type_entry[:list_field]
    self.date_field = nil unless field_type_entry[:calendar]
    self.datetime_field = nil unless field_type_entry[:dt_calendar]
    
    self.default_value = self.list_field.gsub(/(\r\n|\r)/, "\n").split("\n").join(",") if field_type_entry[:list_field]
    self.default_value = self.date_field if field_type_entry[:calendar]
    self.default_value = Time.parse(self.datetime_field).strftime("%Y-%m-%d %H:%M:%S") if field_type_entry[:dt_calendar]
  end
  
  def restore_fields
    field_type_entry = CustomField.field_type_entry_by_key(self.field_type_key)
    self.list_field = self.default_value.split(",").join("\n") if field_type_entry[:list_field]
    self.date_field = self.default_value if field_type_entry[:calendar]
    self.date_field = self.default_value.split(" ")[0] if field_type_entry[:time_field]
    self.datetime_field = self.default_value if field_type_entry[:dt_calendar]
    
    self.default_value = nil if field_type_entry[:list_field] or field_type_entry[:calendar] or field_type_entry[:dt_calendar]
  end
end
