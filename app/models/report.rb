require "securerandom"

class Report < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base
  include Rails.application.routes.url_helpers

  has_many :report_sites, dependent: :destroy, autosave: true
  has_many :sites, :through => :report_sites

  has_many :report_attachments, class_name: '::ReportAttachment', dependent: :destroy, autosave: false
  accepts_nested_attributes_for :report_attachments
  
  validates :title, presence: true
  validates :report_class, presence: true
  validates :site_ids, presence: true

  selectable_attr :report_class do
    update_by_array ReportLogicData.all, when: :everytime
    entry 'base_logic', :base_logic, 'Base Logic'
  end

  attr_accessor :uuid
  attr_accessor :report_model
  attr_accessor :target_model
  
  def self.set_unique_key
    SecureRandom.hex
  end
  
   def invoke(report = nil)
    logic = report_logic
    logic.build_pdf(report)
  end
  
  def set_demo_preview
    logic = report_logic
    self.target_model = logic.get_demo_preview 
  end
  
  def set_preview(target_id)
    logic = report_logic
    self.target_model = logic.get_preview(target_id)
  end
  
  private

  def report_logic
    klass = "::Reports::#{self.report_class.to_s.classify}".safe_constantize
    raise ArgumentError, "invalid report_class: #{self.report_class.inspect}" unless klass.is_a?(Class) && klass.name.start_with?("Reports::")
    klass.new(self)
  end

end
