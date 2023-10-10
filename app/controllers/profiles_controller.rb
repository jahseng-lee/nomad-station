class ProfilesController < ApplicationController
  def success
    # TODO add profile details like display name, email (read only)
    # TODO add link to reset password
    # TODO add link to update email (reconfirm? explore)

    # TODO setup webhooks to listen to Stripe events I care about:
    #   * https://stripe.com/docs/billing/subscriptions/webhooks#events
    # TODO show subscription status:
    #   * if no stripe_customer_id, show "No subscription"
    #   * otherwise, show status of their subscription
    # TODO add link to:
    #   * subscription management using stripe_customer_id, if present
    #   * choose plan page if no customer_id
    raise NotImplementedError, "TODO"
  end
end
