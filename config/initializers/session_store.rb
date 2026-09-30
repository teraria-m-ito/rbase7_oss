# SameSite=None には Secure が必須。本番（HTTPS）で LTI 埋め込み時のセッション用。
# 開発は HTTP では Secure 付きクッキーが送れないため :lax のままにする。
# 埋め込み挙動をローカルで再現する場合は https 起動（例: bin/rails s -b 'ssl://0.0.0.0:3000?key=...'）等で secure: true を検討。
if Rails.env.development? || Rails.env.test?
  Rails.application.config.session_store :active_record_store, same_site: :lax, secure: false
else
  Rails.application.config.session_store :active_record_store, same_site: :none, secure: true
end
Rails.application.config.active_record.use_yaml_unsafe_load = true