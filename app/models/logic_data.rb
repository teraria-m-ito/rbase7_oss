class LogicData
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ActiveModel::Model

  attr_accessor :logic_type
  attr_accessor :logic_name

  
  def self.all
    result = []
    return result if Site.first.nil?
    logic_list = SystemSetting.get_multivalue_list(:logics, Site.first.id)
    logic_list.each do |logic|
      l = LogicData.new
      l.logic_type = logic[:value_div]
      l.logic_name = logic[:value]
      result << [l.logic_type, l.logic_name]
    end
    result
  end
end
