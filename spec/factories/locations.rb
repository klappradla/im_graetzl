FactoryBot.define do
  factory :location do
    name { Faker::Company.name }
    slogan { Faker::Company.catch_phrase }
    description { Faker::Lorem.paragraph }
    contact
    graetzl
    location_category
    cover_photo { Refile::FileDouble.new("cover_photo", "cover_photo.png", content_type: "image/png") }
    avatar { Refile::FileDouble.new("avatar", "avatar.png", content_type: "image/png") }

    trait :pending do
      state {Location.states[:pending]}
    end

    trait :approved do
      state {Location.states[:approved]}
    end
  end
end
