class JobManageError < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  stampable

  belongs_to :job_manage, optional: true

end
