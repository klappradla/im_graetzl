class NotificationMailer < ApplicationMailer
  before_action :prepend_view_paths

  def send_immediate(notification)
    @notification = notification
    @user = @notification.user

    headers(
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "notification-mail",
    )
    mail(
      to: @user.email,
      subject: @notification.mail_subject,
      template_name: "immediate/#{@notification.mail_template}"
    )
  end

  GRAETZL_SUMMARY_BLOCKS = {
    'Neue Locations in deinem Grätzl' => [
      Notifications::NewLocation
    ],
    'Neue Treffen' => [
      Notifications::NewMeeting
    ],
    'Neue Location Updates' => [
      Notifications::NewLocationPost
    ],
    'Neue Ideen im Grätzl' => [
      Notifications::NewUserPost, Notifications::NewAdminPost
    ],
    'Neue Gruppen' => [
      Notifications::NewGroup
    ],
  }

  def summary_graetzl(user, period)
    @user, @period = user, period
    @notifications = user.pending_notifications(@period).where(
      type: GRAETZL_SUMMARY_BLOCKS.values.flatten.map(&:to_s)
    )
    return if @notifications.empty?

    @notifications.update_all(sent: true)

    headers(
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "notification-mail",
    )
    mail(
      to: @user.email,
      from: "imGrätzl.at | Neuigkeiten <neuigkeiten@imgraetzl.at>",
      subject: "#{@user.graetzl.name} - Neue Treffen & Location Updates",
    )
  end

  ROOMS_SUMMARY_BLOCKS = {
    'Neuer Raumteiler Call' => [
      Notifications::NewRoomCall
    ],
    'Neue Räume zum Andocken' => [
      Notifications::NewRoomOffer
    ],
    'Auf der Suche nach Raum' => [
      Notifications::NewRoomDemand
    ],
    'Neuer Tool Offers' => [
      Notifications::NewToolOffer
    ],
  }

  def summary_rooms(user, period)
    @user, @period = user, period
    @notifications = user.pending_notifications(@period).where(
      type: ROOMS_SUMMARY_BLOCKS.values.flatten.map(&:to_s)
    )
    return if @notifications.empty?

    @notifications.update_all(sent: true)

    headers(
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "notification-mail",
    )
    mail(
      to: @user.email,
      from: "imGrätzl.at | Raumteiler <raumteiler@imgraetzl.at>",
      subject: "#{@user.graetzl.name} - Neue Räume & Raumsuchende",
    )
  end

  PERSONAL_SUMMARY_BLOCKS = {
    "Änderungen in einem Treffen" => [
      Notifications::MeetingCancelled, Notifications::MeetingUpdated,
    ],
    "Neuer Kommentar bei" => [
      Notifications::CommentInMeeting, Notifications::CommentInUsersMeeting,
      Notifications::CommentOnAdminPost, Notifications::CommentOnLocationPost,
      Notifications::CommentOnRoomDemand, Notifications::CommentOnRoomOffer,
      Notifications::CommentOnUserPost,
    ],
    'Ebenfalls kommentiert' => [
      Notifications::AlsoCommentedAdminPost, Notifications::AlsoCommentedLocationPost,
      Notifications::AlsoCommentedMeeting, Notifications::AlsoCommentedRoomDemand,
      Notifications::AlsoCommentedRoomOffer, Notifications::AlsoCommentedUserPost,
    ],
    'Neuer Kommentar auf deiner Pinnwand' => [
      Notifications::NewWallComment,
    ]
  }

  GROUP_SUMMARY_TYPES = [
    Notifications::NewGroupMeeting,
    Notifications::NewGroupDiscussion,
    Notifications::NewGroupPost,
    Notifications::NewGroupUser,
    Notifications::CommentOnDiscussionPost,
    Notifications::AlsoCommentedDiscussionPost,
  ]

  def summary_personal(user, period)
    @user, @period = user, period
    @attendee_notifications = user.pending_notifications(@period).where(
      type: "Notifications::AttendeeInUsersMeeting"
    )
    @personal_notifications = user.pending_notifications(@period).where(
      type: PERSONAL_SUMMARY_BLOCKS.values.flatten.map(&:to_s)
    )
    @group_notifications = user.pending_notifications(@period).where(
      type: GROUP_SUMMARY_TYPES.map(&:to_s)
    )

    return if @attendee_notifications.empty? && @personal_notifications.empty? && @group_notifications.empty?

    @attendee_notifications.update_all(sent: true)
    @personal_notifications.update_all(sent: true)
    @group_notifications.update_all(sent: true)

    headers(
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "summary-mail",
    )
    mail(
      to: @user.email,
      from: "imGrätzl.at | Updates <updates@imgraetzl.at>",
      subject: "Persönliche Neuigkeiten für #{@user.first_name} zusammengefasst",
    )
  end

  private

  def prepend_view_paths
    prepend_view_path 'app/views/mailers/notification_mailer'
  end

end
