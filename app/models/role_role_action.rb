class RoleRoleAction < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  belongs_to :role, optional: true
  belongs_to :role_action, optional: true

end
