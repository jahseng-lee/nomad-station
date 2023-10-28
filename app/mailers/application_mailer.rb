class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def default_url_options
    # In heroku, Rails.env.production? is true in
    # staging and production, so custom set an ENV var
    if ENV["RAILS_ENV"] == "staging"
      { host: "https://staging.nomadstation.io" }
    else
      # Use default
      Rails.application.config.action_mailer.default_url_options
    end
  end
end
