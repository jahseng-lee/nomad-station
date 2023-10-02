require "csv"
require 'securerandom'

def seed_database
  # Called at the end but defined up here for
  # ease of reading
  setup_regions
  setup_locations_and_countries
  associate_countries_and_regions
  denomarlize_united_kingdom
  update_bali
  setup_content_account
end

def setup_regions
  if Region.count != 0
    puts "Regions are already set up"
    return
  end

  puts "Creating regions"
  # Add Regions
  [
    "Asia",
    "Europe",
    "United Kingdom",
    "South America",
    "Central America",
    "North America",
    "Africa",
    "Oceania",
    "Middle East",
    "Caribbean",
  ].each do |region_name|
    Region.create!(name: region_name)
  end
  puts "Created regions"
end

def setup_locations_and_countries
  if Location.count != 0 || Country.count != 0
    puts "Locations and countries are already set up"
    return
  end
  puts "Adding locations and countries"

  file_location = Rails.root.join("db", "seedfiles", "worldcities.csv")
  tables = CSV.parse(File.read(file_location), headers: true)

  tables.each_with_index do |row, i|
    puts "Processed line: #{i}" if (i % 1_000) == 0

    country = Country.find_by(name: row["country"])
    if country.nil?
      country = Country.create!(name: row["country"])
    end

    # see db/seedfiles/worldcities.csv
    Location.create!(
      name: row["city_ascii"],
      name_utf8: row["city"],
      country: country,
      population: row["population"].present? ? row["population"] : 0,
    )
  end

  puts "Finished adding locations and countries"
end

def associate_countries_and_regions
  if Country.pluck(:region_id).compact.count != 0
    puts "Already associated countries and regions"
    return
  end
  puts "Associating countries and regions"

  @region = Region.find_by(name: "Asia")
  [
    "India",
    "Philippines",
    "China",
    "Korea, South",
    "Russia",
    "Thailand",
    "Bangladesh",
    "Vietnam",
    "Malaysia",
    "Hong Kong",
    "Singapore",
    "Myanmar",
    "Taiwan",
    "Cambodia",
    "Mongolia",
    "Japan",
    "Brunei",
    "Indonesia",
    "Timor-Leste",
    "Bhutan",
    "Nepal",
    "Laos",
    "Sri Lanka",
    "Maldives",
    "Macau",
    "Armenia",
    "Pakistan",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "South America")
  [
    "Brazil",
    "Argentina",
    "Peru",
    "Colombia",
    "Chile",
    "Bolivia",
    "Ecuador",
    "Venezuela",
    "Paraguay",
    "Uruguay",
    "Suriname",
    "Guyana",
    "Falkland Islands (Islas Malvinas)",
    "South Georgia And South Sandwich Islands",
    "French Guiana",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "Central America")
  [
    "Mexico",
    "Guatemala",
    "Honduras",
    "Nicaragua",
    "Panama",
    "El Salvador",
    "Costa Rica",
    "Belize",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "North America")
  [
    "United States",
    "Canada",
    "Bermuda",
    "Saint Martin",
    "Saint Pierre And Miquelon",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "Europe")
  [
    "Turkey",
    "France",
    "Spain",
    "Germany",
    "Italy",
    "Belarus",
    "Austria",
    "Romania",
    "Poland",
    "Belgium",
    "Hungary",
    "Serbia",
    "Bulgaria",
    "Netherlands",
    "Georgia",
    "Sweden",
    "Croatia",
    "Norway",
    "Greece",
    "Finland",
    "Macedonia",
    "Moldova",
    "Latvia",
    "Denmark",
    "Lithuania",
    "Portugal",
    "Estonia",
    "Slovakia",
    "Albania",
    "Slovenia",
    "Bosnia And Herzegovina",
    "Martinique",
    "Kosovo",
    "Montenegro",
    "Curaçao",
    "Switzerland",
    "Iceland",
    "Luxembourg",
    "Greenland",
    "Vatican City",
    "Sint Maarten",
    "Ireland",
    "Ukraine",
    "Azerbaijan",
    "Czechia",
    "San Marino",
    "Malta",
    "Andorra",
    "Liechtenstein",
    "Aruba",
    "Monaco",
    "Reunion",
    "Faroe Islands",
    "Svalbard",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "United Kingdom")
  [
    "United Kingdom",
    "Gibraltar",
    "Isle Of Man",
    "Jersey",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "Africa")
  [
    "Egypt",
    "Nigeria",
    "Congo (Kinshasa)",
    "Angola",
    "Tanzania",
    "Kenya",
    "Côte D’Ivoire",
    "South Africa",
    "Morocco",
    "Algeria",
    "Ethiopia",
    "Madagascar",
    "Cameroon",
    "Ghana",
    "Zimbabwe",
    "Somalia",
    "Mali",
    "Malawi",
    "Guinea",
    "Uganda",
    "Zambia",
    "Burkina Faso",
    "Mozambique",
    "Senegal",
    "Rwanda",
    "Libya",
    "Chad",
    "Mauritania",
    "Tunisia",
    "Niger",
    "Liberia",
    "Eritrea",
    "Sierra Leone",
    "Central African Republic",
    "Togo",
    "Gabon",
    "Benin",
    "Burundi",
    "Djibouti",
    "Guinea-Bissau",
    "Lesotho",
    "Namibia",
    "Botswana",
    "Equatorial Guinea",
    "Congo (Brazzaville)",
    "Western Sahara",
    "Gambia, The",
    "Swaziland",
    "Mauritius",
    "Cabo Verde",
    "Comoros",
    "Sao Tome And Principe",
    "Mayotte",
    "Seychelles",
    "South Sudan",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "Oceania")
  [
    "Australia",
    "New Zealand",
    "Papua New Guinea",
    "French Polynesia",
    "New Caledonia",
    "Solomon Islands",
    "Fiji",
    "Vanuatu",
    "Samoa",
    "Marshall Islands",
    "Kiribati",
    "Tonga",
    "American Samoa",
    "Micronesia, Federated States Of",
    "Tuvalu",
    "Cook Islands",
    "Northern Mariana Islands",
    "Niue",
    "Guam",
    "Wallis And Futuna",
    "Norfolk Island",
    "Palau",
    "Pitcairn Islands",
    "Christmas Island",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "Middle East")
  [
    "Kuwait",
    "Iran",
    "Sudan",
    "Saudi Arabia",
    "Iraq",
    "Jordan",
    "Afghanistan",
    "Yemen",
    "United Arab Emirates",
    "Uzbekistan",
    "Syria",
    "Kazakhstan",
    "Oman",
    "Qatar",
    "Kyrgyzstan",
    "Turkmenistan",
    "Israel",
    "Tajikistan",
    "Lebanon",
    "Cyprus",
    "Bahrain",
    "Gaza Strip",
    "West Bank",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  @region = Region.find_by(name: "Caribbean")
  [
    "Dominican Republic",
    "Cuba",
    "Haiti",
    "Jamaica",
    "Bahamas, The",
    "Barbados",
    "Saint Lucia",
    "Trinidad And Tobago",
    "Cayman Islands",
    "Saint Vincent And The Grenadines",
    "Antigua And Barbuda",
    "Dominica",
    "Saint Kitts And Nevis",
    "Turks And Caicos Islands",
    "Grenada",
    "Guadeloupe",
    "Virgin Islands, British",
    "Saint Barthelemy",
    "Anguilla",
    "Puerto Rico",
  ].each do |country_name|
    Country.find_by(name: country_name).update!(region: @region)
  end

  puts "Finished associating countries and regions"
end

def denomarlize_united_kingdom
  if Country.find_by(name: "England").present?
    puts "Already denomarlized United Kingdom 'Country'"
    return
  end

  # There are 1800+ locations under "United Kingdom".
  # Won't manually sort them all, but will try to get
  # the big ones + famous ones
  puts "Denormalizing the United Kingdom 'country'"
  @region = Region.find_by(name: "United Kingdom")

  @country = Country.create!(name: "England", region: @region)
  [
    "London",
    "Birmingham",
    "Manchester",
    "Leeds",
    "Newcastle",
    "Birstall",
    "Liverpool",
    "Nottingham",
    "Bristol",
    "Sheffield",
    "Kingston upon Hull",
    "Leicester",
    "Portsmouth",
    "Southampton",
    "Stoke-on-Trent",
    "Coventry",
    "Reading",
    "Derby",
    "Plymouth",
    "Wolverhampton",
    "Milton Keynes",
    "Norwich",
    "Luton",
    "Islington",
    "Swindon",
    "Croydon",
    "Basildon",
    "Bournemouth",
    "Worthing",
    "Ipswich",
    "Middlesbrough",
    "Sunderland",
    "Ilford",
    "Warrington",
    "Slough",
    "Huddersfield",
    "Oxford",
    "York",
    "Poole",
    "Harrow",
    "Saint Albans",
    "Telford",
    "Blackpool",
    "Brighton",
    "Sale",
    "Enfield",
    "Tottenham",
    "Bolton",
    "High Wycombe",
    "Exeter",
    "Solihull",
    "Romford",
    "Preston",
    "Gateshead",
    "Blackburn",
    "Cheltenham",
    "Basingstoke",
    "Maidstone",
    "Colchester",
    "Chelmsford",
    "Wythenshawe",
    "Doncaster",
    "Rotherham",
    "Walthamstow",
    "Rochdale",
    "Bedford",
    "Crawley",
    "Mansfield",
    "Dagenham",
    "Stockport",
    "Darlington",
    "Fyfield",
    "Gillingham",
    "Salford",
    "Eastbourne",
    "Wigan",
    "Hounslow",
    "Wembley",
    "Saint Helens",
    "Worcester",
    "Wakefield",
    "Lincoln",
    "Hemel Hempstead",
    "Newport",
    "Watford",
    "Oldham",
    "Sutton Coldfield",
    "Kettering",
    "Hastings",
    "Hartlepool",
    "Hove",
    "Barnsley",
    "Southport",
    "Aberdeen",
  ].each do |location_name|
    Location.find_by(name: location_name).update!(country: @country)
  end

  @country = Country.create!(name: "Northern Ireland", region: @region)
  [
    "Belfast",
    "Derry",
    "Lisburn",
    "Omagh",
  ].each do |location_name|
    Location.find_by(name: location_name).update!(country: @country)
  end

  @country = Country.create!(name: "Scotland", region: @region)
  [
    "Glasgow",
    "Edinburgh",
    "Dundee",
    "Inverness",
  ].each do |location_name|
    Location.find_by(name: location_name).update!(country: @country)
  end

  @country = Country.create!(name: "Wales", region: @region)
  Location.find_by(name: "Caerdydd").update!(name: "Cardiff", country: @country)
  Location.find_by(name: "Swansea").update!(country: @country)
  Location.find_by(name: "Wrecsam").update!(name: "Wrexham", country: @country)
  Location.find_by(name: "Newport").update!(country: @country)

  puts "Finished denormalizing the United Kingdom 'country'"
end

def update_bali
  # ...I don't know why Bali is part of India in the db
  Location.find_by(name: "Bali").update!(country: Country.find_by(name: "Indonesia"))
end

def setup_content_account
  if User.find_by(email: "content-robot@nomadstation.io").present?
    puts "Already setup 'content-robot@nomadstation.io'"
    return
  end

  puts "Creating content-robot account"
  User.create!(
    email: "content-robot@nomadstation.io",
    # This account should never be logged into
    # so generate a random password
    password: SecureRandom.hex(20)
  )
  puts "Finished creating content-robot account"
end

seed_database
