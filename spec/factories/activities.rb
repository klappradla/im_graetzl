FactoryBot.define do
  factory :activity do
    association :trackable, factory: :meeting
    association :owner, factory: :user
  end
end
