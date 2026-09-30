# coding: utf-8
require_relative '../support/rbase_task_helpers'
require_relative '../../rbase/plugins_symlink_core'
require 'psych'

namespace :rbase do
  namespace :plugins do
    app_root_path = RbaseTaskHelpers.app_root_path

    desc "delete symlinks and set symlinks by using rbase_plugins.yml"
    task :symlink do
      puts "===================================="
      puts "Delete symlinks and set symlinks by using rbase_plugins.yml."
      puts "===================================="
      Rbase::PluginsSymlinkCore.run!(app_root_path)

      puts "===================================="
      puts "Update customizing assets index.js."
      puts "===================================="
      Rake::Task["rbase:plugins:assets_controllers:update"].invoke
    end

    desc "delete route symlinks and set route symlinks"
    task :routes_symlink do
      Rbase::PluginsSymlinkCore.routes_symlink!(app_root_path)
    end
  end
end
