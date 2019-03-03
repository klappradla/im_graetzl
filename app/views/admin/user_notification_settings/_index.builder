context.instance_eval do
  column(:email) { |u| link_to u.email, admin_user_path(u) }
  column("Graetzl") { |u|
    [
      "New Meeting: #{u.enabled_mail_notification(Notifications::NewMeeting)}",
      "New Location: #{u.enabled_mail_notification(Notifications::NewLocation)}",
      "New Location post: #{u.enabled_mail_notification(Notifications::NewLocationPost)}",
      "New User Post: #{u.enabled_mail_notification(Notifications::NewUserPost)}",
      "New Group: #{u.enabled_mail_notification(Notifications::NewGroup)}",
    ].join("<br>").html_safe
  }
  column("Raumteiler") { |u|
    [
      "New Room Offer: #{u.enabled_mail_notification(Notifications::NewRoomOffer)}",
      "New Room Demand: #{u.enabled_mail_notification(Notifications::NewRoomDemand)}",
      "New Room Call: #{u.enabled_mail_notification(Notifications::NewRoomCall)}",
    ].join("<br>").html_safe
  }
  column("Betrifft Mich") { |u|
    [
      "Commented Meeting: #{u.enabled_mail_notification(Notifications::CommentInUsersMeeting)}",
      "Commented Post: #{u.enabled_mail_notification(Notifications::AlsoCommentedLocationPost)}",
      "Commented Wall: #{u.enabled_mail_notification(Notifications::NewWallComment)}",
      "Meeting Attended: #{u.enabled_mail_notification(Notifications::AttendeeInUsersMeeting)}",
      "Meeting Updated: #{u.enabled_mail_notification(Notifications::MeetingUpdated)}",
      "Meeting Cancelled: #{u.enabled_mail_notification(Notifications::MeetingCancelled)}",
    ].join("<br>").html_safe
  }
  column("Groups") { |u|
    [
      "New Discussion: #{u.enabled_mail_notification(Notifications::NewGroupDiscussion)}",
      "New Member: #{u.enabled_mail_notification(Notifications::NewGroupUser)}",
      "New Meeting: #{u.enabled_mail_notification(Notifications::NewGroupMeeting)}",
      "New Post: #{u.enabled_mail_notification(Notifications::NewGroupPost)}",
    ].join("<br>").html_safe
  }
end
