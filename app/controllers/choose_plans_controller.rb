require 'securerandom'

class ChoosePlansController < ApplicationController
  def show
    if current_user.stripe_customer_id.nil? ||
        current_user.cancelled_subscription?
      @checkout_client_reference_id = SecureRandom.hex(32)

      current_user.update!(
        last_checkout_reference: @checkout_client_reference_id
      )
    else
      # Have a subscription already, whether active or cancelled
      # redirect to profile page to allow self management
      redirect_to profile_path
    end
  end
end
