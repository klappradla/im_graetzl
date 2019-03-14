FactoryBot.define do
  factory :post do
    title { Faker::Hipster.sentence(3) }
    content { Faker::Hipster.paragraph }

    factory :user_post, class: 'UserPost' do
      association :author, factory: :user
      graetzl
    end

    factory :location_post, class: 'LocationPost' do
      association :author, factory: :location
      graetzl
    end

    factory :discussion_post, class: 'DiscussionPost' do
      association :author, factory: :group
    end

    factory :admin_post, class: 'AdminPost' do
      association :author, factory: [:user, :admin]
    end
  end
end
