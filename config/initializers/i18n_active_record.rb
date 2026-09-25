require "i18n/backend/active_record"
require Rails.root.join("lib/i18n_translations_cache").to_s

# app/models/translation.rb は Zeitwerk 管理のため、モデル参照は after_initialize 以降で行う
Rails.application.config.to_prepare do
  I18n::Backend::ActiveRecord.configure do |config|
    config.translation_model = ::Translation
    config.cache_translations = true
    # config.cleanup_with_destroy = true # defaults to false
    # config.scope = 'app_scope' # defaults to nil, won't be used
  end
end

Rails.application.config.after_initialize do
  next unless ActiveRecord::Base.connection.data_source_exists?(:translations)

  I18n::Backend::ActiveRecord.configure do |config|
    config.translation_model = ::Translation
    config.cache_translations = true
  end
  I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
  I18n::Backend::ActiveRecord.prepend(SkipSimpleFormArLookup)
  I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
  I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

  # DB翻訳をYAMLより優先する（管理画面で上書きできるようにする）
  I18n.backend = I18n::Backend::Chain.new(
    I18n::Backend::ActiveRecord.new,
    I18n::Backend::Simple.new
  )

  I18n.singleton_class.prepend(Module.new do
    def reload!
      super
      I18nTranslationsCache.restore_after_rails_reload!
    end
  end)
  I18n.singleton_class.prepend(I18nTranslateCache)
  ActiveRecord::Base.singleton_class.prepend(HumanAttributeNameCache)
  I18nTranslationsCache.refresh_if_stale!
rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
  # DB未準備時（migrate前など）はスキップ
end

# ミドルウェアで包むと verbose_query_logs の呼び出し元がすべてこのファイルになるため、
# コントローラ処理開始時にだけ他ワーカーの更新を取り込む。
ActiveSupport::Notifications.subscribe("start_processing.action_controller") do |*_|
  ::CanvasAccount.clear_preloaded_tree_index! if defined?(::CanvasAccount)
  Thread.current[:canvas_default_account_admin_role] = nil
  I18nTranslationsCache.refresh_if_stale!
end
