FactoryBot.define do
  factory :meeting do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    starts_at_date { Date.tomorrow }
    address
    graetzl


    trait :active do
      state { Meeting.states[:active] }
    end

    trait :cancelled do
      state { Meeting.states[:cancelled] }
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false) }
    end
  end
end
