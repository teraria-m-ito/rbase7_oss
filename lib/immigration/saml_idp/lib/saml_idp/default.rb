# encoding: utf-8
module SamlIdp
  module Default
    NAME_ID_FORMAT = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    X509_CERTIFICATE = <<EOS.strip
CHANGE_ME
EOS
    FINGERPRINT = "CHANGE_ME"
    SECRET_KEY = <<EOS
-----BEGIN RSA PRIVATE KEY-----
CHANGE_ME
-----END RSA PRIVATE KEY-----
EOS
    SERVICE_PROVIDER = {
      fingerprint: FINGERPRINT
    }
  end
end
