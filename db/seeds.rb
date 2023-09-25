require "csv"

# Add Regions
[
  "Asia",
  "Europe",
  "Americas",
  "Africa",
  "Pacific"
].each do |region_name|
  Region.create!(name: region_name)
end

puts "Created regions"

# Add countries
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
    city: row["city_ascii"],
    city_utf8: row["city"],
    country: country,
    population: row["population"].present? ? row["population"] : 0,
  )
end

