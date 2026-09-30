class ReportLogicData
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ActiveModel::Model
    attr_accessor :id
  attr_accessor :logic_type
  attr_accessor :logic_name

  def self.all(site_id = nil)
    result = []
    if site_id.present?
      id = site_id.to_i
      return result unless id > 0 && Site.active.exists?(id)
      site_id = id
    else
      site_id = Thread.current[:request].try(:session).try(:[], :active_site_id)
      site_id = site_id.to_i
      site_id = nil unless site_id > 0 && Site.active.exists?(site_id)
      if site_id.blank? && Site.active.count == 1
        site_id = Site.active.limit(1).pick(:id)
      end
      return result if site_id.blank?
    end

    logic_list = SystemSetting.get_multivalue_list(:report_logics, site_id)
    logic_list.each do |logic|
      l = LogicData.new
      l.logic_type = logic[:value_div]
      l.logic_name = logic[:value]
      result << [l.logic_type, l.logic_name]
    end
    result
  end
  
end
