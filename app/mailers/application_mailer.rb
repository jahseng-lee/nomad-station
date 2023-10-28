class ApplicationMailer < ActionMailer::Base
  default from: "jahseng.lee@nomadstation.io"
  layout "mailer"

  def default_url_options
    # In heroku, Rails.env.production? is true in
    # staging and production, so custom set an ENV var
    if ENV["HEROKU_ENV"] == "staging"
      # TODO this doesn't work...
      { host: "https://staging.nomadstation.io" }
    else
      # Use default
      Rails.application.config.action_mailer.default_url_options
    end
  end
end
