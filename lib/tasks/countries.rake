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
    NON_SEED_CITIZENSHIPS = [
      "Chile",
      "Colombia",
      "Peru",
      "Iran",
      "Bangladesh",
      "Bolivia",
      "Panama",
      "Macedonia",
      "Angola",
      "Mozambique",
      "Jordan",
      "Egypt",
      "Sudan",
      "Kenya",
      "Lithuania",
      "Zambia",
      "Uganda",
      "Qatar",
      "Nicaragua",
      "Liberia",
      "Haiti",
      "Israel",
      "Latvia",
      "Albania",
      "Bahamas, The",
      "Suriname",
      "Kosovo",
      "Equatorial Guinea",
      "Reunion",
      "Fiji",
      "Saint Lucia",
      "French Guiana",
      "Samoa",
      "Aruba",
      "Gambia, The",
      "Kiribati",
      "Seychelles",
      "Saint Vincent And The Grenadines",
      "Micronesia, Federated States Of",
      "Uzbekistan",
      "Tuvalu",
      "Vatican City",
      "Sint Maarten",
      "Saint Barthelemy",
      "Saint Pierre And Miquelon",
      "Norfolk Island",
      "Western Sahara",
      "Tajikistan"
    ];

    Country.find_each do |country|
      next if country.locations.empty?

      Country.find_each do |citizenship|
        if Rails.env.production?
          # This guard serves as a "non-visa friendly" country, which
          # is usually a two way street.
          next if citizenship.locations.empty?
          # This is a manually created list of "citzenship" countries
          # which will be initially excluded
          next if NON_SEED_CITIZENSHIPS.include?(citizenship.name)

          if country.id == citizenship.id
            VisaInformation.create!(
              country_id: country.id,
              citizenship_id: country.id,
              body: "You're a citizen of #{country.name}."
            )
            next
          end

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

        puts "Created VisaInformation for citizenship:" \
          " #{citizenship.name},  country: #{country.name}."
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
        puts "Created country: #{country.name}"
      end
    end
  end
end
