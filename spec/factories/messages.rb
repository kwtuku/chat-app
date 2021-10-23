FactoryBot.define do
  factory :message do
    content { Faker::Lorem.word }
    association :user
  end
end
