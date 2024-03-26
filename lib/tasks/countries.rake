namespace :countries do
  desc "Generate generic visa information for all countries"
  task generate_visa_information: :environment do
    Country.find_each do |country|
      if Rails.env.production?
        raise NotImplementedError, "TODO"
      else
        VisaInformation.create!(
          country: country,
          citizenship_id: nil,
          body: "Generic visa information for #{country.name}"
        )
      end
    end
  end
end
