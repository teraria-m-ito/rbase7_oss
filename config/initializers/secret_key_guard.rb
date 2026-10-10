# 本番で secrets.yml のプレースホルダのまま起動すると、署名付き Cookie を誰でも偽造できる
if Rails.env.production?
  placeholder = ->(value) { value.blank? || value.to_s.strip == "CHANGE_ME" }

  if placeholder.call(Rails.application.secret_key_base)
    raise "secret_key_base が未設定です。SECRET_KEY_BASE 環境変数、credentials、または config/secrets.yml に本番用の値を設定してください。"
  end

  if Rails.application.secrets.key?(:encrypt_secure_key) && placeholder.call(Rails.application.secrets.encrypt_secure_key)
    raise "encrypt_secure_key が未設定です。config/secrets.yml に本番用の値を設定してください。"
  end
end
