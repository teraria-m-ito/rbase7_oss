class IssueCustomField < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  self.table_name = "issue_custom_fields"

  include ::SelectableAttr::Base
  include CustomFieldConcern

  belongs_to :issue, inverse_of: :issue_custom_fields
  belongs_to :custom_field, optional: true

  def custom_fields_validate
    self.validate_field
  end

end
