class DeviseMailer < Devise::Mailer
  include PostmarkRails::TemplatedMailerMixin
  include Devise::Controllers::UrlHelpers

  default "Message-ID" => lambda {"<#{SecureRandom.uuid}@nomadr.io>"}
  default from: "jahseng.lee@nomadstation.io"

  def confirmation_instructions(record, token, opts = {})
    self.template_model = ApplicationMailer::DEFAULT_ARGS.merge({
      display_name: record.display_name,
      action_url: confirmation_url(record, confirmation_token: token),
    })

    mail(
      to: record.email,
      postmark_template_alias: "welcome",
      track_opens: "true",
      message_stream: "outbound"
    )
  end

  def reset_password_instructions(record, token, opts = {})
    self.template_model = ApplicationMailer::DEFAULT_ARGS.merge({
      action_url: edit_password_url(record, reset_password_token: token),
      display_name: record.display_name,
    })

    mail(
      to: record.email,
      postmark_template_alias: "reset-password-instructions",
      track_opens: "true",
      message_stream: "outbound"
    )
  end

  def confirmation_instructions(record, token, opts = {})
    raise NotImplementedError, "TODO"
    self.template_model = ApplicationMailer::DEFAULT_ARGS.merge({
      action_url: confirmation_url(record, confirmation_token: token),
      display_name: record.first_name,
    })

    mail(
      to: record.email,
      postmark_template_alias: "confirmation-instructions",
      track_opens: "true",
      message_stream: "outbound"
    )
  end
end
