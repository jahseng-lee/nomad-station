require "csv"

namespace :countries do
  desc "Generate generic visa information for all countries"
  task generate_visa_information: :environment do
    Country.find_each do |country|
      next if country.locations.empty?

      if Rails.env.production?
        VisaInformation.create!(
          country_id: country.id,
          citizenship_id: nil,
          body: ChatGpt.generate_generic_visa_info(country: country)
        )
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
          VisaInformation.create!(
            country_id: country.id,
            citizenship_id: nil,
            body: ChatGpt.generate_visa_info(
              country: country,
              citizenship_country: citizenship
            )
          )
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

  # Some idiot (me) deleted countries without locations before realising
  # I need those...
  desc "Restore deleted countries"
  task restore_deleted: :environment do
    file_location = Rails.root.join("db", "seedfiles", "worldcities.csv")
    tables = CSV.parse(File.read(file_location), headers: true)

    tables.each_with_index do |row, i|
      puts "Processed line: #{i}" if (i % 1_000) == 0

      country = Country.find_by(name: row["country"])
      if country.nil?
        country = Country.create!(name: row["country"])
        put "Created country: #{country.name}"
      end
    end
  end
end
