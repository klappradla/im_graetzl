ActiveAdmin.register User, as: "User Notification Settings" do
  menu parent: 'Users', priority: 2

  actions :index
  #config.filters = false

  scope :all, default: true
  scope :business
  scope :admin

  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select' }
  filter :id, label: 'User', as: :select, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :email

  filter :user_mail_setting, as: :select, collection: proc {[
    ['New Meeting - Weekly','weekly_NewMeeting'],['New Meeting - Daily','daily_NewMeeting'],['New Meeting - Immediate','immediate_NewMeeting'],['New Meeting - Off','off_NewMeeting'],
    ['New Location - Weekly','weekly_NewLocation'],['New Location - Daily','daily_NewLocation'],['New Location - Immediate','immediate_NewLocation'],['New Location - Off','off_NewLocation'],
    ['New Location Post - Weekly','weekly_NewLocationPost'],['New Location Post - Daily','daily_NewLocationPost'],['New Location Post - Immediate','immediate_NewLocationPost'],['New Location Post - Off','off_NewLocationPost'],
    ['New Group - Weekly','weekly_NewGroup'],['New Group - Daily','daily_NewGroup'],['New Group - Immediate','immediate_NewGroup'],['New Group - Off','off_NewGroup'],
    ['New RoomOffer - Weekly','weekly_NewRoomOffer'],['New RoomOffer - Daily','daily_NewRoomOffer'],['New RoomOffer - Immediate','immediate_NewRoomOffer'],['New RoomOffer - Off','off_NewRoomOffer'],
    ['New RoomDemand - Weekly','weekly_NewRoomDemand'],['New RoomDemand - Daily','daily_NewRoomDemand'],['New RoomDemand - Immediate','immediate_NewRoomDemand'],['New RoomDemand - Off','off_NewRoomDemand'],
    ['New ToolOffer - Weekly','weekly_NewToolOffer'],['New ToolOffer - Daily','daily_NewToolOffer'],['New ToolOffer - Immediate','immediate_NewToolOffer'],['New ToolOffer - Off','off_NewToolOffer'],

    ['Commented Content - Weekly','weekly_CommentInUsersMeeting'],['Commented Content - Daily','daily_CommentInUsersMeeting'],['Commented Content - Immediate','immediate_CommentInUsersMeeting'],['Commented Content - Off','off_CommentInUsersMeeting'],
    ['Comment in Meeting - Weekly','weekly_CommentInMeeting'],['Comment in Meeting - Daily','daily_CommentInMeeting'],['Comment in Meeting - Immediate','immediate_CommentInMeeting'],['Comment in Meeting - Off','off_CommentInMeeting'],
    ['Also Commented Content - Weekly','weekly_AlsoCommentedLocationPost'],['Also Commented Content - Daily','daily_AlsoCommentedLocationPost'],['Also Commented Content - Immediate','immediate_AlsoCommentedLocationPost'],['Also Commented Content - Off','off_AlsoCommentedLocationPost'],
    ['New Attendee in Meeting - Weekly','weekly_AttendeeInUsersMeeting'],['New Attendee in Meeting - Daily','daily_AttendeeInUsersMeeting'],['New Attendee in Meeting - Immediate','immediate_AttendeeInUsersMeeting'],['New Attendee in Meeting - Off','off_AttendeeInUsersMeeting'],

  ]}

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
    column(:commented_content) { |u| u.enabled_mail_notification(Notifications::CommentInUsersMeeting) }
    column(:also_commented_content) { |u| u.enabled_mail_notification(Notifications::AlsoCommentedLocationPost) }
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
