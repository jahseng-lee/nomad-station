class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :trackable and :omniauthable
  devise :confirmable,
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  has_many :reviews

  validates :display_name,
    length: { minimum: 5, maximum: 50 },
    uniqueness: true

  def subscription_status
    if self[:subscription_status].present?
      self[:subscription_status].capitalize
    elsif user.stripe_customer_id.nil?
      "None"
    end
  end

  def active_subscription?
    self[:subscription_status] == "active"
  end

  def cancelled_subscription?
    # NOTE this is not the same as 'None' as user previously has a
    #      subscription
    #      this is also not the same as !active_subscription as
    #      'paused' can be a valid status
    self[:subscription_status] == "canceled"
  end
end
