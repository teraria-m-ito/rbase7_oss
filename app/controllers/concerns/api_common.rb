require 'base64'
require 'openssl'

module ApiCommon
  extend ActiveSupport::Concern

  # def to_decrypt(plain_text)
  #   begin
  #     crypt_keyword = ::SystemSetting.get_setting(:crypt_keyword, current_site_id)
  #
  #     return plain_text if crypt_keyword.blank?
  #
  #     data = Base64.decode64(plain_text)
  #     engine = OpenSSL::Cipher.new('AES-256-CBC')
  #     engine.decrypt
  #     engine.key = crypt_keyword
  #     engine.iv = data[0..15]
  #     res = engine.update(data[16..]) + engine.final
  #     res.force_encoding("UTF-8")
  #   rescue => e
  #     ::Rails.logger.error("error:" + e.message)
  #     raise e
  #   end

  CIPHER = "aes-256-cbc"

  def to_decrypt(message)
    DWHCache.to_decrypt(message)
  end
end
