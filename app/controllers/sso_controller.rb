class SsoController < ApplicationController
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  respond_to :html

  before_action :set_sso_type, only: [:index, :consume, :metadata]
  def index
    case @sso_type
    when "saml2" then
      request = OneLogin::RubySaml::Authrequest.new
      redirect_to(request.create(saml_settings), allow_other_host: true)
    end
  end

  desc :auth_as => :index
  def consume
    case @sso_type
    when "saml2" then
      response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], {skip_conditions: true})
      response.settings = saml_settings
      # We validate the SAML Response and check if the user already exists in the system
      if response.is_valid?
        admin_user = AdminUser.where(email: response.nameid.strip).first
        unless admin_user
          admin_user = ::AdminUser.new
          admin_user.login_from = response.settings.idp_entity_id
          admin_user.name = response.attributes["username"]
          admin_user.email = response.attributes["email"]
          site = Site.first
          admin_user.site_ids = [site.id]
          if response.attributes["userRole"].present?
            admin_user.role_id = ::Role.where(role_short_name: response.attributes["userRole"]).first.id
          else
            admin_user.role_id = ::Role.where("role_short_name = 'STUDENT'").order(:id).first.id
            admin_user.role_id = ::Role.where("role_short_name = 'member'").order(:id).first.id unless admin_user.role_id
            admin_user.role_id = ::Role.where("role_short_name <> 'admin'").order(:id).first.id unless admin_user.role_id
          end
          admin_user.status_div_key = :accepted
          admin_user.password = SecureRandom.urlsafe_base64 if admin_user.new_record?

          admin_user.save!
        end
        sign_in(admin_user) unless current_admin_user
        flash[:notice] = t("devise.sessions.signed_in")

        # authorize_success, log the user
        # session[:userid] = response.nameid
        # session[:attributes] = response.attributes
      else
        flash[:notice] = t("views.common.fail_login_message")
        # authorize_failure  # This method shows an error message
        # List of errors is available in response.errors array
      end
      if session[:direct_url]
        redirect_to session[:direct_url], status: :see_other
      else
        redirect_to root_path, status: :see_other
      end
    end
  end

  desc :auth_as => :index
  def metadata
    @setting = saml_settings
    @x509_certificate = File.read(Rails.root.join("config/credentials/idp_certificate.pem"))
    if @x509_certificate
      @x509_certificate = @x509_certificate.to_s
                                           .gsub(/-----BEGIN CERTIFICATE-----/,"")
                                           .gsub(/-----END CERTIFICATE-----/,"")
                                           .gsub(/\n/, "")
    end

    render 'sso/metadata', formats: [:xml]
  end

  private
  def saml_settings
    site = Site.first
    sso_type = ::SystemSetting.get_setting(:sso_type, site.id)

    @logic = eval("::Logic::Sso#{@sso_type.classify}Logic.new")
    @logic.settings
  end

  def set_sso_type
    site = Site.first
    @sso_type = ::SystemSetting.get_setting(:sso_type, site.id)
  end
end
