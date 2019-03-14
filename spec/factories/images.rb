FactoryBot.define do
  factory :image do
    file_id { Faker::Internet.password(20) }
    imageable { nil }
  end
end
