class WebhooksController < ApplicationController
  class StripeCustomerNotFound < StandardError; end

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: { message: e.message }}, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: { message: e.message, extra: "Sig verification failed" }}, status: :bad_request
      return
    end

    # Handle the event
    case event.type
    when "checkout.session.completed"
      data = event.data["object"]
      user = User.find_by(last_checkout_reference: data["client_reference_id"])
      if user.nil?
        raise StripeCustomerNotFound, "Couldn't find a User with last_checkout_reference: #{data["client_reference_id"]}. Stripe customer id: #{data["customer"]}, event.type: 'checkout.session.completed'"
      end

      user.update!(
        stripe_customer_id: data["customer"]
      )

      subscription = Stripe::Subscription.retrieve(
        data["subscription"]
      )
      user.update!(
        subscription_status: subscription["status"]
      )
    when "customer.subscription.deleted", "customer.subscription.paused", "customer.subscription.resumed"
      # In these cases, just updated the subscription with the correct status
      data = event.data["object"]

      user = User.find_by(stripe_customer_id: data["customer"])
      if user.nil?
        raise StripeCustomerNotFound, "Couldn't find a User with stripe_customer_id: #{data['customer']}. event.type: #{event.type}"
      end

      user.update!(subscription_status: data["status"])
    when "customer.subscription.updated"
      data = event.data["object"]

      user = User.find_by(stripe_customer_id: data["customer"])
      if user.nil?
        # NOTE: for now, just return a 200
        #       It turns out that this always happens _before_ a checkout
        #       session is completed; this means that anytime someone signs
        #       up we'd raise and error as the user wouldn't have their
        #       customer_id yet.
        #       Ideally, log these events somewhere but _don't_ raise an
        #       exception


        render json: { message: :success }
        return
        # raise StripeCustomerNotFound, "Couldn't find a User with stripe_customer_id: #{data['customer']}. event.type: #{event.type}"
      end

      # Always update the status just in case
      user.update!(subscription_status: data["status"])

      if data["cancel_at_period_end"] == true
        # TODO this is called when a subscription is canceled.
        #      the subsciption remains active til the end of
        #      the billing period.
        #
        #      Ideally we listen to this and check if
        #      `cancel_at_period_end == true`, then save this
        #      via. a flag to the user. Then we can show a
        #      warning banner to the user that there subscription
        #      will end soon
      end
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }
  end

  private

  def endpoint_secret
    ENV["STRIPE_SIGNING_SECRET"]
  end
end
