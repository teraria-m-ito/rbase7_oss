module Logic
  class SsoSaml2Logic
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    attr_accessor :sp_cert_fingerprint
    attr_accessor :display_name
    attr_accessor :mailto

    def settings
      settings = OneLogin::RubySaml::Settings.new

      site = Site.first
      if saml2_setting_string = ::SystemSetting.get_setting(:sso_setting, site.id)
        saml2_setting = JSON.parse(saml2_setting_string, symbolize_names: true)

        settings.assertion_consumer_service_url = saml2_setting[:assertion_consumer_service_url]
        settings.sp_entity_id                   = saml2_setting[:sp_entity_id]
        settings.idp_entity_id                  = saml2_setting[:idp_entity_id]
        settings.idp_sso_service_url            = saml2_setting[:idp_sso_service_url]
        settings.idp_sso_service_binding        = saml2_setting[:idp_sso_service_binding]
        settings.idp_slo_service_url            = saml2_setting[:idp_slo_service_url]
        settings.idp_slo_service_binding        = saml2_setting[:idp_slo_service_binding]

        idp_finger_print = ::SystemSetting.get_setting(:idp_finger_print, site.id)
        if idp_finger_print.present?
          settings.idp_cert_fingerprint = idp_finger_print
        else
          settings.idp_cert_fingerprint           = File.open("#{Rails.root}/#{saml2_setting[:idp_cert_fingerprint]}").read if saml2_setting[:idp_cert_fingerprint].present?
        end
        settings.idp_cert_fingerprint_algorithm = saml2_setting[:idp_cert_fingerprint_algorithm]
        settings.name_identifier_format         = saml2_setting[:name_identifier_format]

        settings.authn_context = saml2_setting[:authn_context]

        # Optional bindings (defaults to Redirect for logout POST for ACS)
        settings.single_logout_service_binding      = saml2_setting[:single_logout_service_binding]
        settings.assertion_consumer_service_binding = saml2_setting[:assertion_consumer_service_binding]

        self.sp_cert_fingerprint                = File.open("#{Rails.root}/#{saml2_setting[:sp_cert_fingerprint]}").read if saml2_setting[:sp_cert_fingerprint].present?
        self.display_name = saml2_setting[:display_name]
        self.mailto = saml2_setting[:mailto]

        settings
      end
    end

    # SSO(SAML IdP)応答に、SP固有のグループ属性（RedashGroups等）を追加する。
    # 本体は素通しで、付与の有無や内容はプラグイン（rbase_wid）側で issuer を見て決定する。
    # @param attributes [Hash] SamlIdp 用の attributes 定義
    # @param issuer [String, nil] SAMLリクエストの issuer（SP entity ID）
    # @return [Hash] attributes
    def self.add_saml_groups(attributes, issuer = nil)
      attributes
    end
  end
end