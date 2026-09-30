class ReportSite < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include BelongsToSite

  belongs_to :report, optional: true
end
