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

  def active_subscription?
    # TODO how do I implement this? How do I keep this in sync?
    false
  end
end
