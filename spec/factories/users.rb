FactoryBot.define do
  factory :user do
    avatar { [Faker::Avatar.image, ''].sample }
    name { Faker::Name.name }
    sequence(:email) { |n| "#{n}#{Faker::Internet.email(domain: 'example.com')}" }
    faker_password = Faker::Internet.password(min_length: 6)
    password { faker_password }
    password_confirmation { faker_password }
  end
end
