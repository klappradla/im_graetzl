require 'faker'

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    graetzl
    confirmed_at {Date.today}

    trait :admin do
      role {User.roles[:admin]}
    end

    factory :user_with_enabled_website_notifications do
      after(:create) do |user|
        user.enabled_website_notifications = Notification.subclasses.inject(0) { |sum, k| k::BITMASK | sum }
        user.save
      end
    end

  end
end
