class UserMailer < ApplicationMailer
  include PostmarkRails::TemplatedMailerMixin

  default "Message-ID" => lambda {"<#{SecureRandom.uuid}@nomadr.io>"}
  default from: "jahseng.lee@nomadstation.io"

  def notify_admin_signup(record)
    self.template_model = ApplicationMailer::DEFAULT_ARGS.merge({
      user_email: record.email
    })

    mail(
      to: "jahseng.lee@nomadstion.io",
      postmark_template_alias: "user-signed-up",
      track_opens: "true",
      message_stream: "outbound"
    )
  end
end

