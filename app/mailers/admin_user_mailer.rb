class AdminUserMailer < ApplicationMailer

  def password_reset(mail_template, site_id, resource, token)
    @resource = resource
    @token = token
    @body = ERB.new(mail_template.body).result(binding)

    send_to = resource.email
    send_from = ::SystemSetting.get_setting(:system_mail_address, site_id)

    mail(to: send_to, from: send_from, subject: mail_template.subject) do |format|
      format.text
    end
  end
end
