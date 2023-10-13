class SubscriptionsController < ApplicationController
  def manage
    portal_session = Stripe::BillingPortal::Session.create({
      customer: current_user.stripe_customer_id,
      return_url: profile_url,
    })

    redirect_to(
      portal_session["url"],
      allow_other_host: true
    )
  end
end

