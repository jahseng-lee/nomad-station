FactoryBot.define do
  factory :visa_information do
    country { create(:country) }
    citizenship { create(:country) }

    body { "Some information about visas for a country" }
  end
end
