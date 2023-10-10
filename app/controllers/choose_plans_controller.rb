require 'securerandom'

class ChoosePlansController < ApplicationController
  def show
    if current_user.stripe_customer_id.present?
      # Have a subscription already, whether active or cancelled
      # redirect to profile page to allow self management
      redirect_to profile_path
    else
      @checkout_client_reference_id = SecureRandom.hex(32)

      User.update!(
        last_checkout_reference: @checkout_client_reference_id
      )
    end
  end
end
