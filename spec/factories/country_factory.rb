FactoryBot.define do
  factory :country do
    name { "New Zealand" }

    region { Region.create!(name: "Oceania") }
  end
end
