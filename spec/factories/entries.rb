FactoryBot.define do
  factory :entry do
    association :room
    association :user
  end
end
