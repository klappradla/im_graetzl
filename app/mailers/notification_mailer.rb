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
    'Neue Toolteiler in deinem Grätzl' => [
      Notifications::NewToolOffer
    ],
    'Neuer Raumteiler Call' => [
      Notifications::NewRoomCall
    ],
    'Neue Räume zum Andocken' => [
      Notifications::NewRoomOffer
    ],
    'Auf der Suche nach Raum' => [
      Notifications::NewRoomDemand
    ],
  }

  def summary_graetzl(user, period)
    @user, @period = user, period
    @notifications = user.pending_notifications(@period).where(
      type: GRAETZL_SUMMARY_BLOCKS.values.flatten.map(&:to_s)
    )
    # BEGIN CHANGES MICHAEL
    # CLEAN NOTIFICATIONS FROM NOT NECESSARY DOUBLES (could be in meetings -> because of rake task set new date)
    notifications = {}
    @notifications.each do |notification|
      next if notification.activity.key != 'meeting.create' # check only for meeting.create
      @notifications.delete(notification) if notifications["#{notification.activity.key}.#{notification.activity.id}.#{notification.activity.trackable.id}"].present?
      #puts notification.activity.key
      #puts notification.activity.id
      #puts notification.activity.trackable.id
      notifications["#{notification.activity.key}.#{notification.activity.id}.#{notification.activity.trackable.id}"] = true
    end
    #puts notifications
    # END CHANGES MICHAEL
    return if @notifications.empty?

    headers(
      "X-MC-Tags" => "summary-graetzl-mail",
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "notification-mail",
    )
    mail(
      to: @user.email,
      from: "imGrätzl.at <neuigkeiten@imgraetzl.at>",
      subject: "Neues aus dem Grätzl #{@user.graetzl.name}",
    )
    @notifications.update_all(sent: true)
  end

  PERSONAL_SUMMARY_BLOCKS = {
    'Neuer Kommentar auf deiner Pinnwand' => [
      Notifications::NewWallComment,
    ],
    "Änderungen an einem Treffen" => [
      Notifications::MeetingCancelled, Notifications::MeetingUpdated,
    ],
    "Neuer Kommentar bei" => [
      Notifications::CommentInMeeting, Notifications::CommentInUsersMeeting,
      Notifications::CommentOnAdminPost, Notifications::CommentOnLocationPost,
      Notifications::CommentOnRoomDemand, Notifications::CommentOnRoomOffer,
      Notifications::CommentOnUserPost, Notifications::AlsoCommentedToolOffer,
    ],
    'Ebenfalls kommentiert' => [
      Notifications::AlsoCommentedAdminPost, Notifications::AlsoCommentedLocationPost,
      Notifications::AlsoCommentedMeeting, Notifications::AlsoCommentedRoomDemand,
      Notifications::AlsoCommentedRoomOffer, Notifications::AlsoCommentedUserPost,
      Notifications::AlsoCommentedToolOffer,
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

    @notifications = {}
    @notifications[:atendees] = user.pending_notifications(@period).where(
      type: "Notifications::AttendeeInUsersMeeting"
    )
    @notifications[:personal] = user.pending_notifications(@period).where(
      type: PERSONAL_SUMMARY_BLOCKS.values.flatten.map(&:to_s)
    )
    @notifications[:groups] = user.pending_notifications(@period).where(
      type: GROUP_SUMMARY_TYPES.map(&:to_s)
    )

    # BEGIN CHANGES MICHAEL
    # CLEAN PERSONAL NOTIFICATIONS FROM NOT NECESSARY DOUBLES
    personal_notifications = {}
    @notifications[:personal].each do |notification|
      @notifications.delete(notification) if personal_notifications["#{notification.activity.key}.#{notification.activity.id}.#{notification.activity.trackable.id}"].present?
      personal_notifications["#{notification.activity.key}.#{notification.activity.id}.#{notification.activity.trackable.id}"] = true
    end
    puts '--------- PERSONAL NOTIFICATIONS CLEANED: -------'
    puts personal_notifications
    puts @notifications[:personal]

    # CLEAN GROUP NOTIFICATIONS FROM NOT NECESSARY DOUBLES
    group_notifications = {}
    @notifications[:groups].each do |notification|
      @notifications.delete(notification) if group_notifications["#{notification.activity.key}.#{notification.activity.id}.#{notification.activity.trackable.id}"].present?
      group_notifications["#{notification.activity.key}.#{notification.activity.id}.#{notification.activity.trackable.id}"] = true
    end
    puts '--------- GROUP NOTIFICATIONS CLEANED: -------'
    puts group_notifications
    # END CHANGES MICHAEL
    puts @notifications[:groups]

    puts @notifications

    if @notifications.values.all?(&:empty?)
      return
    end

    headers(
      "X-MC-Tags" => "summary-personal-mail",
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "summary-mail",
    )
    mail(
      to: @user.email,
      from: "imGrätzl.at | Updates <updates@imgraetzl.at>",
      subject: "Persönliche Neuigkeiten für #{@user.first_name} zusammengefasst",
    )
    @notifications.values.each { |n| n.update_all(sent: true) }
  end

  private

  def prepend_view_paths
    prepend_view_path 'app/views/mailers/notification_mailer'
  end

end
