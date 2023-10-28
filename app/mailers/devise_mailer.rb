class DeviseMailer < Devise::Mailer
  include PostmarkRails::TemplatedMailerMixin
  include Devise::Controllers::UrlHelpers

  default "Message-ID" => lambda {"<#{SecureRandom.uuid}@nomadr.io>"}

  def reset_password_instructions(record, token, opts = {})
    raise NotImplementedError, "TODO"
  end

  def confirmation_instructions(record, token, opts = {})
    self.template_model = {
      product_url: "https://www.nomadstation.io",
      product_name: "Nomadstation",
      display_name: record.display_name,
      action_url: confirmation_url(record, confirmation_token: token),
      support_email: "jahseng.lee@nomadstation.io",
    }

    mail(
      to: record.email,
      postmark_template_alias: "welcome",
      track_opens: "true",
      message_stream: "outbound"
    )
  end

  def password_change(record, opts = {})
    raise NotImplementedError, "TODO"
  end
end
