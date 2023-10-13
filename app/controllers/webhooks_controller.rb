class WebhooksController < ApplicationController
  class CheckoutUserNotFound < StandardError; end

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
      user = User.find_by(last_checkout_reference: event.data["object"]["client_reference_id"])
      if user.nil?
        raise CheckoutUserNotFound, "Couldn't find a User with last_checkout_reference: #{event.data["object"]["client_reference_id"]}. Stripe customer id: #{event.data["object"]["customer"]}"
      end

      user.update!(
        stripe_customer_id: event.data["object"]["customer"]
      )

      subscription = Stripe::Subscription.retrieve(
        event.data["object"]["subscription"]
      )
      user.update!(
        subscription_status: subscription["status"]
      )
      # TODO double check that the status appears as active.
      #      This hook is async, so may need to do some turbo magic
      #      to update the element on the screen
    when ""
      # TODO deal with other subscription events
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
