FactoryBot.define do
  factory :zuckerl do
    location
    title { Faker::Lorem.characters(80) }
    description { Faker::Lorem.paragraph }

    trait :draft do
      aasm_state { 'draft' }
    end

    trait :paid do
      aasm_state { 'paid' }
    end

    trait :pending do
      aasm_state { 'pending' }
    end

    trait :live do
      aasm_state { 'live' }
    end

    trait :cancelled do
      aasm_state { 'cancelled' }
    end
  end
end
