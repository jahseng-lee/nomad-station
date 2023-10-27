class EligibleCountriesForVisa < ApplicationRecord
  belongs_to :visa
  belongs_to :eligible_country,
    class_name: "Country",
    foreign_key: "country_id"

  validates :eligible_country, uniqueness: { scope: :visa }
end
