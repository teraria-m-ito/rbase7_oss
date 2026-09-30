# frozen_string_literal: true

# Rails を起動せずに rbase プラグインの symlink・rbase_gems/Gemfile 更新などを行う。
# Capistrano では bundle install より前に実行し、Gemfile に path gem が載った状態で
# Bundler が解決できるようにする（production の eager load で AdminUser が先に読まれる問題の回避）。
#
# 単体実行: ruby lib/rbase/plugins_symlink_core.rb /path/to/app_root

require "fileutils"
require "psych"
require_relative "../tasks/support/rbase_task_helpers"

module Rbase
  module PluginsSymlinkCore
    module_function

    def run!(app_root_path)
      Dir.chdir(app_root_path) do
        symlink_plugin_directories!(app_root_path)
        update_rbase_gems_gemfile!(app_root_path)
        write_load_plugins!(app_root_path)
        ensure_init_rb!(app_root_path)
        routes_symlink!(app_root_path)
        symlink_deploy_configs!(app_root_path)
      end
    end

    def symlink_plugin_directories!(app_root_path)
      plugin_paths = Dir["rbase_gems/rbase_*"]
      RbaseTaskHelpers.remove_symlinks_with_warning(plugin_paths, "WARNING: these plugins aren't symlink")

      rbase_plugin_paths = RbaseTaskHelpers.load_rbase_plugin_paths
      rbase_plugin_paths.each do |plugin_path|
        FileUtils.cd(File.join(app_root_path, "rbase_gems"), verbose: true) do
          FileUtils.ln_sf("../#{plugin_path}", ".", verbose: true)
        end
      end
      FileUtils.cd(app_root_path, verbose: true)
    end

    def update_rbase_gems_gemfile!(app_root_path)
      Dir.chdir(app_root_path) do
        puts "create rbase_gems/Gemfile"
        if File.exist?("rbase_gems/Gemfile")
          FileUtils.rm("rbase_gems/Gemfile.tmp", verbose: true) if File.exist?("rbase_gems/Gemfile.tmp")
          found = false
          File.open("rbase_gems/Gemfile.tmp", "a") do |f_out|
            File.open("rbase_gems/Gemfile", "rt") do |f_in|
              f_in.each_line do |line|
                if found
                  break
                else
                  f_out.puts line
                end
                found = true if line.start_with?("#customize gems")
              end
            end
            break if found
          end
          FileUtils.mv("rbase_gems/Gemfile.tmp", "rbase_gems/Gemfile", force: true)
        end

        rbase_plugin_paths = RbaseTaskHelpers.load_rbase_plugin_paths
        File.open("rbase_gems/Gemfile", "a") do |f|
          rbase_plugin_paths.each do |plugin_path|
            plugin_name = RbaseTaskHelpers.plugin_name_from_path(plugin_path)
            f.puts "gem '#{plugin_name}', path: '#{plugin_name}'"
            puts "add ==> gem '#{plugin_name}', path: '#{plugin_name}'"
          end
        end
      end
    end

    def write_load_plugins!(app_root_path)
      Dir.chdir(app_root_path) do
        FileUtils.rm("rbase_gems/load_plugins.rb", verbose: true) if File.exist?("rbase_gems/load_plugins.rb")
        puts "create rbase_gems/load_plugins.rb"
        rbase_plugin_paths = RbaseTaskHelpers.load_rbase_plugin_paths
        File.open("rbase_gems/load_plugins.rb", "a") do |f|
          rbase_plugin_paths.each do |plugin_path|
            plugin_name = RbaseTaskHelpers.plugin_name_from_path(plugin_path)
            f.puts "require './rbase_gems/#{plugin_name}/init'"
            puts "add ==> require './rbase_gems/#{plugin_name}/init'"
          end
        end
      end
    end

    def ensure_init_rb!(app_root_path)
      rbase_plugin_paths = RbaseTaskHelpers.load_rbase_plugin_paths
      rbase_plugin_paths.each do |plugin_path|
        plugin_name = RbaseTaskHelpers.plugin_name_from_path(plugin_path)
        init_file_path = "#{app_root_path}/rbase_gems/#{plugin_name}/init.rb"
        if File.exist?(init_file_path)
          puts "exits #{plugin_name}/init.rb"
          next
        end

        text = <<~EOS
          # Include hook code here
          require './lib/rbase/plugin_module'

          Rbase::PluginModule.register(
          )
        EOS
        File.write(init_file_path, text)
        puts "create #{plugin_name}/init.rb"
      end
    end

    def routes_symlink!(app_root_path)
      Dir.chdir(app_root_path) do
        puts "===================================="
        puts "Create Symbolic link to Routes file in the customization part."
        puts "===================================="

        plugin_paths = Dir["config/routes/*.rb"]
        RbaseTaskHelpers.remove_symlinks_with_warning(plugin_paths, "WARNING: these routes.rb aren't symlink")

        plugin_paths = Dir["rbase_gems/rbase_*/config/routes.rb"]
        plugin_paths.each do |plugin_path|
          plugin_name_match = plugin_path.match(/\Arbase_gems\/(rbase_.*)\/config\/routes.rb\Z/)
          next unless plugin_name_match && plugin_name_match[1]

          plugin_name = plugin_name_match[1]
          puts "[routes file]symlink:#{plugin_name}"
          FileUtils.mkdir_p(File.join(app_root_path, "config", "routes")) unless File.exist?(File.join(app_root_path, "config", "routes"))
          FileUtils.ln_sf(
            "../../#{plugin_path}",
            File.join(app_root_path, "config", "routes", "#{plugin_name}.rb"),
            verbose: true
          )
        end
      end
    end

    def symlink_deploy_configs!(app_root_path)
      Dir.chdir(app_root_path) do
        puts "delete link for deploy scripts."
        plugin_paths = Dir["config/deploy/*.rb"]
        plugin_paths.each do |plugin_path|
          next unless File.symlink?(plugin_path)

          puts "[deploy file]remove symlink:#{plugin_path}"
          FileUtils.rm_f(plugin_path)
        end

        puts "create link for deploy scripts."
        plugin_paths = Dir["rbase_gems/rbase_*/config/deploy/*.rb"]
        plugin_paths.each do |plugin_path|
          filename = File.basename(plugin_path)
          puts "[deploy file]symlink:#{plugin_path}"
          FileUtils.ln_sf(
            "../../#{plugin_path}",
            File.join("config", "deploy", filename.to_s),
            verbose: true
          )
        end
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  root = ARGV[0] || File.expand_path("../..", __dir__)
  Rbase::PluginsSymlinkCore.run!(root)
end
