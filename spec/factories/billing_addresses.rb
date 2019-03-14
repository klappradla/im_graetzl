FactoryBot.define do
  factory :billing_address do
    location
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
  end
end
