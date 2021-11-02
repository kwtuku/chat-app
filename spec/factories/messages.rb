FactoryBot.define do
  factory :message do
    content { Faker::Lorem.word }
    association :room
    association :user
  end
end
