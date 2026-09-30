# coding: utf-8

namespace :rbase do
  desc "prepare task when deployed"
  task :prepare_task_when_deployed => :environment do
    ::SystemSetting.prepare_deployed
  end

  desc "restart task"
  task :restart_task => :environment do
    ::Rake::Task["assets:precompile"].invoke
    # passengerのrestart
    `passenger-config restart-app` if Rails.env == 'production'
  end

  desc "restart task (legacy alias)"
  task :retart_task => :environment do
    ::Rake::Task["rbase:restart_task"].invoke
  end
end
