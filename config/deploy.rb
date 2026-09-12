# config valid only for Capistrano 3.1
#lock '3.17.0'

set :application, 'rbase7_oss'
set :repo_url, 'https://github.com/teraria-m-ito/rbase7_ldi_release.git'

set :git_submodules, true

set :git_http_username, "CHANGE_ME"
#set :git_http_password, ENV.fetch("GITHUB_TOKEN")
set :git_http_password, "CHANGE_ME"

set :deploy_to, '/home/xec/capistrano'

# set :scm, :git

set :use_sudo, false

set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, 'ruby-3.1.2'      # Defaults to: 'default'

set :format, :pretty

set :log_level, :debug

set :stages, %w(development)
set :default_stage, "development"

set :linked_dirs, %w(log tmp/pids tmp/cache public/system public/uploads tmp/images public/images app/javascript/widgets config/credentials)
set :default_env, { path: '/home/xec/.rvm/gems/ruby-3.1.2/bin:/home/xec/.rvm/rubies/ruby-3.1.2/bin:$PATH' } 

set :linked_files, fetch(:linked_files, []).push('config/secrets.yml').push('config/database.yml').push('rbase_plugins.yml').push('.env')

set :keep_releases, 3

set :delayed_job_workers, 3


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'

  # after "bundle:install" do
    # download "config/credentials/production.key", "config/credentials/production.key", via: :scp
  # end

  # task :plugins_symlink do
  #   on roles(:app) do
  #     within release_path do
  #       execute :bundle, :exec, :rake, 'rbase:plugins:symlink' #プラグインのリンク設定
  #     end
  #   end
  # end
  # before "bundler:install", "deploy:plugins_symlink"

  task :plugins_symlink do
    on roles(:app) do
      within release_path do
        execute :ruby, release_path.join("lib/rbase/plugins_symlink_core.rb"), release_path.to_s
      end
    end
  end
  before "bundler:install", "deploy:plugins_symlink"

  namespace :permission_update do
    task :exec_rake do
      on roles(:app) do
        within release_path do
          execute :bundle, :exec, :rake, 'rbase:setup_role RAILS_ENV=production'
        end
      end
    end
  end

  before "deploy:restart", "permission_update:exec_rake"

  # rbase_plugins.yml for deployment
  namespace :rbase_plugins do
    task :yml_upload do
      on roles(:app) do
        within shared_path do
          unless test "[ -f #{shared_path}/rbase_plugins.yml ]"
            upload!('rbase_plugins.yml', ".rbase_plugins.yml")
          end
        end
      end
    end
  end
  before "deploy:check", "rbase_plugins:yml_upload"

  task :restart_task do
    on roles(:app) do

      yml_path = shared_path.join("config/database.yml")

      unless test("[ -f #{yml_path} ]")
        info "database.yml not found: #{yml_path}"
        next
      end

      raw = capture(:cat, yml_path)
      rendered = ERB.new(raw).result

      config = YAML.safe_load(rendered, aliases: true)

      prod = config["production"] || {}
      has_primary = prod.key?("primary")

      puts "restart_task primary:#{has_primary}"
      within release_path do
        execute :bundle, :config, :unset, :deployment
        # Rails を起動する前に rbase_gems/Gemfile を整える（production eager load 対策）
        execute :ruby, release_path.join("lib/rbase/plugins_symlink_core.rb"), release_path.to_s
        execute :bundle, :install
        execute :bundle, :exec, :rake, "rbase:plugins:assets_controllers:update RAILS_ENV=production"
        execute :bundle, :exec, :rake, 'db:migrate:primary RAILS_ENV=production' if has_primary
        execute :bundle, :exec, :rake, 'db:migrate RAILS_ENV=production' unless has_primary
        # execute :bundle, :config, :frozen
        execute :bundle, :exec, :rake, 'rbase:prepare_task_when_deployed RAILS_ENV=production'
      end
    end
  end
  before "deploy:assets:precompile", "deploy:restart_task"

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :cp, "config/environments/production_#{fetch(:target_env)}.rb",  "config/environments/production.rb"
        # execute :bundle, :exec, :rake, 'bower:install'
        # execute :bundle, :exec, :rake, 'db:migrate:primary RAILS_ENV=production'
        execute :bundle, :exec, :rake, 'rbase:setup_role RAILS_ENV=production'
        execute :touch, "tmp/restart.txt"
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  after :finishing, 'deploy:cleanup'
end
