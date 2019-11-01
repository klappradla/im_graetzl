context.instance_eval do
  column(:email) { |u| link_to u.email, admin_user_path(u) }
  column("Graetzl") { |u|
    [
      "<span class='mailtype'>New Meeting: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewMeeting)}'>#{u.enabled_mail_notification(Notifications::NewMeeting)}</span>",
      "<span class='mailtype'>New Location: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewLocation)}'>#{u.enabled_mail_notification(Notifications::NewLocation)}</span>",
      "<span class='mailtype'>New Location Post: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewLocationPost)}'>#{u.enabled_mail_notification(Notifications::NewLocationPost)}</span>",
      "<span class='mailtype'>New User Post: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewUserPost)}'>#{u.enabled_mail_notification(Notifications::NewUserPost)}</span>",
      "<span class='mailtype'>New Group: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewGroup)}'>#{u.enabled_mail_notification(Notifications::NewGroup)}</span>",
      "<span class='mailtype'>New Room Offer: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewRoomOffer)}'>#{u.enabled_mail_notification(Notifications::NewRoomOffer)}</span>",
      "<span class='mailtype'>New Room Demand: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewRoomDemand)}'>#{u.enabled_mail_notification(Notifications::NewRoomDemand)}</span>",
      "<span class='mailtype'>New Room Call: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewRoomCall)}'>#{u.enabled_mail_notification(Notifications::NewRoomCall)}</span>",
      "<span class='mailtype'>New Tool Offer: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewToolOffer)}'>#{u.enabled_mail_notification(Notifications::NewToolOffer)}</span>",
    ].join("<br>").html_safe
  }
  column("Betrifft Mich") { |u|
    [
      "<span class='mailtype'>Commented Content: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::CommentInUsersMeeting)}'>#{u.enabled_mail_notification(Notifications::CommentInUsersMeeting)}</span>",
      "<span class='mailtype'>Also Commented: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::AlsoCommentedLocationPost)}'>#{u.enabled_mail_notification(Notifications::AlsoCommentedLocationPost)}</span>",
      "<span class='mailtype'>Commented Wall: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewWallComment)}'>#{u.enabled_mail_notification(Notifications::NewWallComment)}</span>",
      "<span class='mailtype'>Meeting Attended: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::AttendeeInUsersMeeting)}'>#{u.enabled_mail_notification(Notifications::AttendeeInUsersMeeting)}</span>",
      "<span class='mailtype'>Meeting Updated: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::MeetingUpdated)}'>#{u.enabled_mail_notification(Notifications::MeetingUpdated)}</span>",
      "<span class='mailtype'>Meeting Cancelled: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::MeetingCancelled)}'>#{u.enabled_mail_notification(Notifications::MeetingCancelled)}</span>",
    ].join("<br>").html_safe
  }
  column("Groups") { |u|
    [
      "<span class='mailtype'>New Discussion: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewGroupDiscussion)}'>#{u.enabled_mail_notification(Notifications::NewGroupDiscussion)}</span>",
      "<span class='mailtype'>New Member: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewGroupUser)}'>#{u.enabled_mail_notification(Notifications::NewGroupUser)}</span>",
      "<span class='mailtype'>New Meeting: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewGroupMeeting)}'>#{u.enabled_mail_notification(Notifications::NewGroupMeeting)}</span>",
      "<span class='mailtype'>New Post: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewGroupPost)}'>#{u.enabled_mail_notification(Notifications::NewGroupPost)}</span>",
    ].join("<br>").html_safe
  }
end
