FactoryBot.define do
  factory :curator do
    graetzl
    user
    website { Faker::Internet.url }
    name { Faker::Internet.user_name }
  end
end
