ActiveAdmin.register User, as: "User Notification Settings" do
  menu parent: 'Users', priority: 2

  actions :index
  config.filters = false

  scope :all, default: true
  scope :business
  scope :admin

  index { render 'index', context: self }

  csv col_sep: ',' do
    column :id
    column :email
    column(:new_meeting) { |u| u.enabled_mail_notification(Notifications::NewMeeting) }
    column(:new_location) { |u| u.enabled_mail_notification(Notifications::NewLocation) }
    column(:new_location_post) { |u| u.enabled_mail_notification(Notifications::NewLocationPost) }
    column(:new_user_post) { |u| u.enabled_mail_notification(Notifications::NewUserPost) }
    column(:new_group) { |u| u.enabled_mail_notification(Notifications::NewGroup) }
    column(:new_room_offer) { |u| u.enabled_mail_notification(Notifications::NewRoomOffer) }
    column(:new_room_demand) { |u| u.enabled_mail_notification(Notifications::NewRoomDemand) }
    column(:new_room_call) { |u| u.enabled_mail_notification(Notifications::NewRoomCall) }
    column(:commented_meeting) { |u| u.enabled_mail_notification(Notifications::CommentInUsersMeeting) }
    column(:commented_post) { |u| u.enabled_mail_notification(Notifications::AlsoCommentedLocationPost) }
    column(:commented_wall) { |u| u.enabled_mail_notification(Notifications::NewWallComment) }
    column(:meeting_attendee) { |u| u.enabled_mail_notification(Notifications::AttendeeInUsersMeeting) }
    column(:meeting_updated) { |u| u.enabled_mail_notification(Notifications::MeetingUpdated) }
    column(:meeting_cancelled) { |u| u.enabled_mail_notification(Notifications::MeetingCancelled) }
    column(:new_group_discussion) { |u| u.enabled_mail_notification(Notifications::NewGroupDiscussion) }
    column(:new_group_user) { |u| u.enabled_mail_notification(Notifications::NewGroupUser) }
    column(:new_group_meeting) { |u| u.enabled_mail_notification(Notifications::NewGroupMeeting) }
    column(:new_group_post) { |u| u.enabled_mail_notification(Notifications::NewGroupPost) }
  end

end
