FactoryBot.define do
  factory :contact do
    website { Faker::Internet.url }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
  end
end
