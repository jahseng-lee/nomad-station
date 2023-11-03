FactoryBot.define do
  factory :channel do
    sequence :name do |n|
      "Chat channel no. #{n}"
    end
  end
end
