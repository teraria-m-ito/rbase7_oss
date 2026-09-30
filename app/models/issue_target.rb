class IssueTarget < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  belongs_to :issue, optional: true
  belongs_to :target, polymorphic: true, optional: true
end
