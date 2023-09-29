class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :trackable and :omniauthable
  devise :confirmable,
    :database_authenticatable,
    # :registerable, # NOTE: disable signup for now
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  has_many :reviews
end
