class RoleAction < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  has_many :role_role_actions
  has_many :roles, :through => :role_role_actions

  validates :controller_name,
    uniqueness: {
      scope: [:action_name]
    }
    
  scope :auth_as_index, -> { where(auth_as: 'index')}
  scope :auth_as_show, -> { where(auth_as: 'show')}
  scope :auth_as_create, -> { where(auth_as: 'create')}
  scope :auth_as_update, -> { where(auth_as: 'update')}
  scope :auth_as_destory, -> { where(auth_as: 'destroy')}
  scope :auth_as_others, -> { where.not(auth_as: ['index', 'show', 'create', 'update','destroy'])}
  
  scope :post_path, -> { where.not(action_name: ['new', 'edit'])}
  
  scope :ordered, -> { order "display_name ASC" }

end
