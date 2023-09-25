class Location < ApplicationRecord
  belongs_to :country

  validates :city, :city_utf8, presence: true
end
