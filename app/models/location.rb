class Location < ApplicationRecord
  belongs_to :country

  validates :name, :name_utf8, presence: true
end
