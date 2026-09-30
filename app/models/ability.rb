class Ability
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include CanCan::Ability
  # def initialize(user)
    # if user.nil?
      # cannot :manage, :all
      # return 
    # end
# 
# #    can :manage, :all
#     
    # can_role_actions = user.role.role_actions.all
    # canot_role_actions = RoleAction.where("id not in (?)", can_role_actions.map(&:id)).all
    # ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
    # ::Rails.logger.debug("can_role_actions #{can_role_actions.size}")
    # ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
#     
    # can_role_actions.each do |role_action|
      # can :manage, "#{role_action.controller_path}/#{role_action.action_name}".to_sym
      # ::Rails.logger.debug("can :manage, #{role_action.controller_path}/#{role_action.action_name}")
    # end
#     
    # ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
    # ::Rails.logger.debug("can_role_actions #{can_role_actions.size}")
    # ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
    # canot_role_actions.each do |role_action|
      # next if role_action.auth_as.blank?
      # cannot :manage, "#{role_action.controller_path}/#{role_action.action_name}".to_sym
      # ::Rails.logger.debug("cannot :manage, #{role_action.controller_path}/#{role_action.action_name}")
    # end
#     
  # end
  
  def initialize(user, controller_name, action_name, force = false)
    if force
      can :manage, :all
      return
    end

    if user.nil?
      can :manage, :all
      return 
    end
    
    if user.role.role_short_name == 'admin'
      can :manage, :all
      return 
    end

    user_role_action = user.role.role_actions.where(controller_path: controller_name).where(action_name: convert_action(action_name)).first
    role_action = RoleAction.where(controller_path: controller_name).where(action_name: convert_action(action_name)).first

    # descでauth_asのみを指定している場合は、auth_asで定義されているアクションの許可／不許可を参照する
    if role_action and role_action.action_display_name.blank? and role_action.auth_as.present?
      role_action = RoleAction.where(controller_path: controller_name).where(action_name: convert_action(role_action.auth_as)).first
      user_role_action = user.role.role_actions.select{|x| x.id == role_action.id}.first
    end

    ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
    ::Rails.logger.debug("controller_path: #{controller_name} action_name: #{convert_action(action_name)}(#{action_name})")

    # assetsのエラーは許可で通す
    if controller_name == "errors" and action_name == "routing_error"
      can :manage, :all
      return
    end

    # role_actionがnilの場合は、定義されていないアクションであり、その場合は許可する
    if !role_action.nil? && user_role_action.nil? && !user.role.role_actions.to_a.empty?
      ::Rails.logger.debug("cannot controller_path:#{role_action.try(:controller_path)} action_name:#{role_action.try(:action_name)}")
      ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
      cannot :manage, :all
      return
    end
    ::Rails.logger.debug("can controller_path:#{role_action.try(:controller_path)} action_name:#{role_action.try(:action_name)}")
    ::Rails.logger.debug("------------------------------------------------------------------------------------------------------")
    can :manage, :all
    
    # case role_action.try(:auth_as)
    # when "index"
      # can :read, :all
    # when "show"
      # can :read, :all
    # when "create"
      # can :create, :all
    # when "update"
      # can :update, :all
    # when "destroy"
      # can :destroy, :all
    # when "other"
      # can :destroy, :all
    # else
      # cannot :manage, :all
    # end
  end

  def is_enable?
    self.permissions[:can].present?
  end

  private
  def convert_action(action)
    {"new" => "create", "edit" => "update"}[action] || action
  end
end