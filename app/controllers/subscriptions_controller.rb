class SubscriptionsController < ApplicationController
  def profile_section
    if current_user.active_subscription? &&
        current_user.stripe_customer_id.present? # Admins will probably
                                                 # have no
                                                 # stripe_customer_id
      @portal_session_url = Stripe::BillingPortal::Session.create({
        customer: current_user.stripe_customer_id,
        return_url: profile_url,
      })["url"]
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "subscription-status-section",
          partial: "profiles/subscription_status_section",
          locals: {
            user: current_user
          }
        )
      end
    end
  end
end

