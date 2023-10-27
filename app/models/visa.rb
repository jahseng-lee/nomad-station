class Visa < ApplicationRecord
  belongs_to :country

  has_many :eligible_countries_for_visas
  has_many :eligible_countries,
    through: :eligible_countries_for_visas,
    class_name: "Country"

  validates :name, presence: true
end
