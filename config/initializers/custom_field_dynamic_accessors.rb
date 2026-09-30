# frozen_string_literal: true

# CustomFieldDynamicAccessors を include する本体モデルのキャッシュをリロード時に破棄する
# （rbase_gems 配下のクラスは、各 gem の initializer で追加する）
Rails.application.config.to_prepare do
  %w[Issue AdminUser].each do |name|
    klass = name.safe_constantize
    next unless klass&.respond_to?(:reset_custom_field_dynamic_access_cache!)

    klass.reset_custom_field_dynamic_access_cache!
  end
end
