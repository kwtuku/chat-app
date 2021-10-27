FactoryBot.define do
  factory :room do
    name { Faker::Lorem.word }
    room_type { [0, 1].sample }
    slug { Faker::Lorem.word }
  end
end
