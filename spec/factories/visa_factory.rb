FactoryBot.define do
  factory :visa do
    country { create(:country) }
    sequence(:name) { |n| "#{country} visa no. #{n}" }
  end
end
