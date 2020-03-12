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
    ['Treffen - Wöchentlich','weekly_NewMeeting'],['Treffen - Täglich','daily_NewMeeting'],['Treffen - Sofort','immediate_NewMeeting'],['Treffen - Aus','off_NewMeeting'],
    ['Location - Wöchentlich','weekly_NewLocation'],['Location - Täglich','daily_NewLocation'],['Location - Sofort','immediate_NewLocation'],['Location - Aus','off_NewLocation'],
    ['Location Post - Wöchentlich','weekly_NewLocationPost'],['Location Post - Täglich','daily_NewLocationPost'],['Location Post - Sofort','immediate_NewLocationPost'],['Location Post - Aus','off_NewLocationPost'],
    ['Gruppe - Wöchentlich','weekly_NewGroup'],['Gruppe - Täglich','daily_NewGroup'],['Gruppe - Sofort','immediate_NewGroup'],['Gruppe - Aus','off_NewGroup'],
    ['Habe Raum - Wöchentlich','weekly_NewRoomOffer'],['Habe Raum - Täglich','daily_NewRoomOffer'],['Habe Raum - Sofort','immediate_NewRoomOffer'],['Habe Raum - Aus','off_NewRoomOffer'],
    ['Suche Raum - Wöchentlich','weekly_NewRoomDemand'],['Suche Raum - Täglich','daily_NewRoomDemand'],['Suche Raum - Sofort','immediate_NewRoomDemand'],['Suche Raum - Aus','off_NewRoomDemand'],
    ['Raum Call - Wöchentlich','weekly_NewRoomCall'],['Raum Call - Täglich','daily_NewRoomCall'],['Raum Call - Sofort','immediate_NewRoomCall'],['Raum Call - Aus','off_NewRoomCall'],
    ['Toolteiler - Wöchentlich','weekly_NewToolOffer'],['Toolteiler - Täglich','daily_NewToolOffer'],['Toolteiler - Sofort','immediate_NewToolOffer'],['Toolteiler - Aus','off_NewToolOffer'],
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
