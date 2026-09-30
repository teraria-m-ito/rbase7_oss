# coding: utf-8

namespace :rbase do
  desc "setup role for rbase."
  task :setup_role => :environment do
    except = [
      :"DeviseController",
      :"AdminApplicationController",
      :"Devise::SessionsController",
      :"Devise::RegistrationsController",
      :"Devise::ConfirmationsController",
      :"Devise::UnlocksController",
      :"Devise::PasswordsController",
      :"Devise::OmniauthCallbacksController",
      :"AdminUsers::SessionsController",
      # :"AdminUsers::RegistrationsController",
      :"AdminUsers::ConfirmationsController",
      :"AdminUsers::UnlocksController",
      :"AdminUsers::PasswordsController",
      :"AdminUsers::OmniauthCallbacksController"
    ]
    Rails.application.eager_load!
    role_action_ids = []
    ActiveRecord::Base.transaction do
      # 新規権限を追加する
      ApplicationController.descendants.each do |controller|
        next if except.include?(controller.to_s.to_sym)
        controller.prepare_action_descriptions
        klass_prestruct = controller.prestruct
        puts "setup for [#{controller.to_s}][#{klass_prestruct[:display_name]}][#{klass_prestruct[:controller_path]}]"
        klass_prestruct.method_descriptions.each do |action_name, description|
          next if action_name =~ /^devise_/
          next if action_name =~ /^.*ApplicationController$/
          next if [:new, :edit].include?(action_name)
          auth_as = description[:auth_as].nil? ? ApplicationController::ACTION_TO_CATEGORY_NAME[action_name.to_s] : description[:auth_as]
#          unless controller.action_methods.include?(auth_as.to_s)
#            raise "'#{auth_as.to_s}' action not found in #{controller.to_s} #{controller.action_methods.to_a.sort.inspect}"
#          end
          puts "save or update [#{action_name}][#{description[:display_name]}][#{auth_as}]"
          target_role_action = RoleAction.where(controller_name: controller.to_s).where(action_name: action_name).first ||
            RoleAction.new({ controller_name: controller.to_s, action_name: action_name })
          target_role_action.assign_attributes({
            controller_path: "#{klass_prestruct[:controller_path]}",
            display_name: klass_prestruct[:display_name].blank? ? nil : "function.#{klass_prestruct[:display_name]}",
            auth_as: auth_as,
            action_display_name: description[:display_name].blank? ? nil : "function.action.#{description[:display_name]}"
          })
          target_role_action.save!
          role_action_ids << target_role_action.id
        end
      end
      # 消去した権限を削除する
      RoleAction.where.not(id: role_action_ids).delete_all
    end
  end
end
