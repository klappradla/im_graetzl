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
      "<span class='mailtype'>New Tool Offer: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewToolOffer)}'>#{u.enabled_mail_notification(Notifications::NewToolOffer)}</span>",
    ].join("<br>").html_safe
  }
  column("Betrifft Mich") { |u|
    [
      "<span class='mailtype'>Commented Content: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::CommentOnRoomOffer)}'>#{u.enabled_mail_notification(Notifications::CommentOnRoomOffer)}</span>",
      "<span class='mailtype'>Also Commented C.: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::AlsoCommentedRoomOffer)}'>#{u.enabled_mail_notification(Notifications::AlsoCommentedRoomOffer)}</span>",
      "<span class='mailtype'>Commented Post: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::CommentOnComment)}'>#{u.enabled_mail_notification(Notifications::CommentOnComment)}</span>",
      "<span class='mailtype'>Also Commented Post: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::AlsoCommentedComment)}'>#{u.enabled_mail_notification(Notifications::AlsoCommentedComment)}</span>",
      "<span class='mailtype'>Comment in Meeting: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::CommentInMeeting)}'>#{u.enabled_mail_notification(Notifications::CommentInMeeting)}</span>",
      "<span class='mailtype'>Meeting New Attendee: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::AttendeeInUsersMeeting)}'>#{u.enabled_mail_notification(Notifications::AttendeeInUsersMeeting)}</span>",
      "<span class='mailtype'>Commented Wall: </span><span class='status_tag #{u.enabled_mail_notification(Notifications::NewWallComment)}'>#{u.enabled_mail_notification(Notifications::NewWallComment)}</span>",
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
