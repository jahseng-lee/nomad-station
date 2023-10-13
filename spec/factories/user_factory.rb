FactoryBot.define do
  factory :user do
    sequence :display_name do |n|
      "Bruce Banner clone #{n}"
    end
    sequence :email do |n|
      "gamma.radiation.#{n}@email.com"
    end
    password { "HulkBeatsThor" }
    admin { false }

    after(:create) { |user| user.confirm }
  end
end
