require_relative "boot"

require "rails/all"

require_relative '../lib/obsoleted.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rbase7
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.i18n.available_locales = %i[ja en]
    config.i18n.default_locale = :ja

    config.active_model.i18n_customize_full_message = true
    
    # config.to_prepare do
      # Devise::SessionsController.layout "application_without_login"
    # end

    config.autoload_paths += %W(#{Rails.root}/lib #{Rails.root}/app/forms)

    # `lib/**/*.rb` を列挙すると rbase プラグイン分の O(n) で起動が極端に遅くなる（共有ディスク上では特に）。
    # 各 path gem の `lib` を1つずつ autoload ルートに足せば足りる。
    Rails.root.glob("rbase_gems/rbase_*/lib").sort.each do |lib_path|
      next unless lib_path.directory?
      path = lib_path.to_s
      next if config.autoload_paths.include?(path)
      config.autoload_paths << path
    end

    # localeのカスタマイズ部の登録（RBASE_GEMS_ORDER の順。後勝ちで上書き）
    # カレントディレクトリに依存しないよう、アプリのルートを基準に探す
    plugin_locales_paths = Dir.glob("rbase_gems/rbase_*/locales", base: File.expand_path("..", __dir__))
    if ENV["RBASE_GEMS_ORDER"].present?
      gem_names = plugin_locales_paths.map { |path| path[%r{rbase_gems/(rbase_[^/]+)/locales}, 1] }.compact
      sort_list = ENV["RBASE_GEMS_ORDER"].split(",").map(&:strip).reject(&:blank?)
      ordered_gem_names = (sort_list & gem_names) + (gem_names - sort_list)
      plugin_locales_paths = ordered_gem_names.map { |name| "rbase_gems/#{name}/locales" }
    end
    plugin_locales_paths.each do |plugin_locales_path|
      yml_files = Dir[Rails.root.join(plugin_locales_path, "*.yml")]
      next if yml_files.empty?

      puts "add locale path:#{yml_files}"
      config.i18n.load_path += yml_files
    end

    # migrationのカスタマイズ部の登録
    plugin_locales_paths = Dir.glob("rbase_gems/rbase_*/migrations", base: File.expand_path("..", __dir__))
    plugin_locales_paths.each do |plugin_locales_path|
      config.paths['db/migrate'] << plugin_locales_path
    end

    config.session_store :cookie_store
    
    #host設定 すべて受け付ける
    config.hosts.clear
    
    config.lti_settings = Rails.application.config_for(:lti_settings)
    # LMS から RBASE を経由して表示する連携先が、遷移元の完全な URL（クエリ文字列を含む）を必要とするため unsafe-url とする。
    # トークンを URL に含む認証画面は ApplicationController で same-origin に絞る
    config.action_dispatch.default_headers['Referrer-Policy'] = 'unsafe-url'
    # 埋め込みの可否は Content-Security-Policy の frame-ancestors（LMS_HOST）で制御する。
    # X-Frame-Options: SAMEORIGIN が残ると LMS からの埋め込みも拒否されるため削除する
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    # 連携先のサイトから RBASE へ POST で戻る場合があるため、送信元（Origin）の一致は確認しない。
    # CSRF トークンの検証は有効（外部から受ける POST は、各アクションで署名検証などを行ったうえで個別に除外する）
    config.action_controller.forgery_protection_origin_check = false
    
    config.action_controller.include_all_helpers = false
    
    config.action_view.preload_links_header = false

    config.active_job.queue_adapter = :delayed_job

    config.active_record.writing_role = :default
    config.active_record.reading_role = :readonly

    # ログファイル名は「<RBASE_LOG_NAME><環境名>_rotate.log」（例: RBASE_LOG_NAME=rbase_ → rbase_production_rotate.log）
    if ENV['RAILS_ENV'] == 'production'
      config.logger = ActiveSupport::Logger.new("#{Rails.root}/log/#{ENV['RBASE_LOG_NAME']}#{ENV['RAILS_ENV'].downcase}_rotate.log", 22, 10*1024*1024)

      class FormatterWithThread < Logger::Formatter
        Format = "[pid:%d #%s] %s %5s %s\n"
        def call(severity, time, progname, msg)
          Format % [
            $$,
            (Thread.current[:name] || Thread.current.object_id.to_s(16)),
            format_datetime(time), severity,
            msg2str(msg)]
        end
      end

      config.log_level = (ENV['RBASE_LOG_LEVEL'] || 'debug').downcase.to_sym
      # production で config.logger を差し替えた場合、インスタンスの severity が DEBUG のままにならないことがある
      begin
        config.logger.level = ::Logger.const_get(config.log_level.to_s.upcase)
      rescue NameError
        config.logger.level = ::Logger::DEBUG
      end
    else
      config.log_level = (ENV['RBASE_LOG_LEVEL'] || 'debug').downcase.to_sym
    end

    config.after_initialize do
      ## カスタマイズ部のinitializers読込
      initializers = []

      puts "-----------------------------------------------------"
      Dir.glob(Rails.root.join('rbase_gems', '*', 'config', 'initializers', '*.rb')).each do |path|
        initializers << {file: File.basename(path), path: path}
      end
      initializers.sort_by { |h| h[:file] }.each do |sorted|
        puts "custom initializers:#{sorted[:file]}"
        require sorted[:path]
      end
      puts "-----------------------------------------------------"

      # environments で設定した config.log_level を、実際の Rails.logger（および AR）に反映する
      if Rails.logger
        sym = Rails.application.config.log_level
        sev =
          begin
            ::Logger.const_get(sym.to_s.upcase)
          rescue NameError
            ::Logger::DEBUG
          end
        Rails.logger.level = sev
      end
      if defined?(::ActiveRecord::Base) && ::ActiveRecord::Base.logger&.respond_to?(:level=)
        ::ActiveRecord::Base.logger.level = Rails.logger.level
      end
    end
  end

end
