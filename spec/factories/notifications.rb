FactoryBot.define do
  factory :notification do
    user
    seen {false}
    bitmask {1}
    type {'Notifications::NewMeeting'}

    trait :with_activity do
      activity
    end

    factory :notification_new_meeting, class: 'Notifications::NewMeeting' do
      bitmask {Notifications::NewMeeting::BITMASK}
      type {Notifications::NewMeeting}
    end

    factory :notification_also_commented_meeting, class: 'Notifications::NewMeeting' do
    end

    # factory :notification_new_meeting, class: 'Notifications::NewMeeting' do
    # end
    #
    # factory :notification_new_meeting, class: 'Notifications::NewMeeting' do
    # end
    #
    # factory :notification_new_meeting, class: 'Notifications::NewMeeting' do
    # end
  end
end
