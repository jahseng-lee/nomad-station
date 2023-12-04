FactoryBot.define do
  factory :eligible_countries_for_visa do
    visa { create(:visa) }
    eligible_country { create(:country) }
  end
end
