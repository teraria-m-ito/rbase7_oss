require 'i18n/backend/active_record'

# app/models/translation.rb は Zeitwerk 管理のため、モデル参照は after_initialize 以降で行う
Rails.application.config.to_prepare do
  I18n::Backend::ActiveRecord.configure do |config|
    config.translation_model = ::Translation
    # config.cache_translations = true # defaults to false
    # config.cleanup_with_destroy = true # defaults to false
    # config.scope = 'app_scope' # defaults to nil, won't be used
  end
end

Rails.application.config.after_initialize do
  next unless ActiveRecord::Base.connection.data_source_exists?(:translations)

  I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
  I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
  I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

  # DB翻訳をYAMLより優先する（管理画面で上書きできるようにする）
  I18n.backend = I18n::Backend::Chain.new(
    I18n::Backend::ActiveRecord.new,
    I18n::Backend::Simple.new
  )
rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
  # DB未準備時（migrate前など）はスキップ
end
