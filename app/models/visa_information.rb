class VisaInformation < ApplicationRecord
  # NOTE: for citizenship, id: nil means "generic", for generic
  #       visa information such as a non-user or user with no citizenship
  #       info
  belongs_to :citizenship,
    foreign_key: :country_id,
    optional: true,
    class_name: "Country"
  belongs_to :country

  def self.generic(country:)
    VisaInformation.find_by!(
      country: country,
      citizenship_id: nil
    )
  end
end
