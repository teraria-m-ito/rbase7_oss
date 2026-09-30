module AdminHelper
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  def to_id(path)
    path.gsub(/\//, "_").split("?")[0]
  end
end