FactoryBot.define do
  factory :going_to do
    user
    meeting

    trait :initiator do
      role { 'initiator' }
    end

    trait :attendee do
      role { 'attendee' }
    end
  end
end
