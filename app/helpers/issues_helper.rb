module IssuesHelper
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  def operator_select(field_type)
    result = []
    case field_type
    when :select
      result = ::Issues::SearchConditions.condition_ope_type_select_options
    else
      result = ::Issues::SearchConditions.condition_ope_type_text_options
    end
    result
  end
end
