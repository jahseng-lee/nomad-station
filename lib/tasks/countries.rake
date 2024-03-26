namespace :countries do
  desc "Generate generic visa information for all countries"
  task generate_visa_information: :environment do
    Country.find_each do |country|
      next if country.locations.empty?

      if Rails.env.production?
        raise NotImplementedError, "TODO"
      else
        VisaInformation.create!(
          country_id: country.id,
          citizenship_id: nil,
          body: "Generic visa information for #{country.name}"
        )
      end
    end
  end

  desc "Generate citizenship specific visa information for all countries"
  task generate_visa_information_for_citizenships: :environment do
    Country.find_each do |country|
      next if country.locations.empty?

      Country.find_each do |citizenship|
        if Rails.env.production?
          raise NotImplementedError, "TODO"
        else
          VisaInformation.create!(
            country_id: country.id,
            citizenship_id: citizenship.id,
            body: "Specific visa information for users with" \
            " citizenship: #{citizenship.name}, for country:" \
            " #{country.name}"
          )
        end
      end
    end
  end
end
