class AdminSetting < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  selectable_attr :menus do
    entry 'sites', :sites, 'Sites', url: "admin_sites_path(clear: true)", icon: "fas fa-sitemap", display_order: 10
    entry 'roles', :roles, 'Roles', url: "admin_roles_path(clear: true)", icon: "fas fa-toggle-on", display_order: 20
    entry 'users', :users, 'Users', url: "admin_users_path(clear: true)", icon: "far fa-address-book", display_order: 30
    entry 'issue_types', :issue_types, 'Issue Types', url: "admin_issue_types_path(clear: true)", icon: "fas fa-ticket-alt", display_order: 40
    entry 'workflow', :workflows, 'Workflow', url: "admin_workflows_path(clear: true)", icon: "fas fa-retweet", display_order: 50
    entry 'state_flows', :state_flows, 'State Flows', url: "admin_state_flows_path(clear: true)", icon: "fas fa-share-square", display_order: 60
    entry 'custom_fields', :custom_fields, 'Custom fields', url: "admin_custom_fields_path(clear: true)", icon: "fas fa-border-style", display_order: 70
    entry 'mail_templates', :mail_templates, 'Mail Templates', url: "admin_mail_templates_path(clear: true)", icon: "fa fa-envelope-open", display_order: 80
    entry 'reports', :reports, 'Reports', url: "admin_reports_path(clear: true)", icon: "fa fa-file-alt", display_order: 90
    entry 'system_setting', :system_setting, 'System Setting', url: "admin_system_settings_path(clear: true)", icon: "fas fa-wrench", display_order: 100

    update_with_plugins(:AdminSetting, :added_entries_for_menus)
  end

  def self.added_entries_for_menus(mod); end

end