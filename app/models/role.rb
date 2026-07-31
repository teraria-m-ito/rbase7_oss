class Role < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  has_many :role_role_actions
  has_many :role_actions, :through => :role_role_actions

  has_many :admin_users
  accepts_nested_attributes_for :role_role_actions,  :allow_destroy => true
  
  validates :role_name, presence: true
  validates :role_short_name, 
    presence: true,
    length: { maximum: 16 },
    format: { with: /\A[a-z0-9_]+\z/i }
  
  
  def deletable?
    self.deletable
  end

  def copy
    result = false
    begin
      ::ActiveRecord::Base.transaction do
        copy_role = self.dup
        copy_role.role_name = "#{copy_role.role_name}_コピー"
        copy_role.role_short_name = "#{copy_role.role_short_name}_COPY"

        copy_role.role_role_actions.build
        self.role_role_actions.each do |role_role_action|
          copy_role.role_role_actions << role_role_action.dup
        end
        copy_role.save!
      end
      result = true
    rescue => e
      Rails.logger.error e.full_message
      Rails.logger.error e.backtrace.join("\n")
    end
    result
  end
end
