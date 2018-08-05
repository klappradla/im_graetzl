class Notification::SummaryMail
  include MailUtils

  SUMMARY_TYPES = {}
  SUMMARY_TYPES[:graetzl] = {
    from_email: "neuigkeiten@imgraetzl.at",
    from_name: "imGrätzl.at | Neuigkeiten",
    blocks: [
      {
        name: 'Neue Locations in deinem Grätzl',
        types: [Notifications::NewLocation]
      },
      {
        name: 'Neue Treffen',
        types: [Notifications::NewMeeting]
      },
      {
        name: 'Neue Location Updates',
        types: [Notifications::NewLocationPost]
      },
      {
        name: 'Neue Ideen im Grätzl',
        types: [Notifications::NewUserPost, Notifications::NewAdminPost]
      },
    ]
  }

  SUMMARY_TYPES[:rooms] = {
    from_email: "raumteiler@imgraetzl.at",
    from_name: "imGrätzl.at | Raumteiler",
    blocks: [
      {
        name: 'Neuer Raumteiler Call',
        types: [Notifications::NewRoomCall]
      },
      {
        name: 'Neue Räume zum Andocken',
        types: [Notifications::NewRoomOffer]
      },
      {
        name: 'Auf der Suche nach Raum',
        types: [Notifications::NewRoomDemand]
      },
    ]
  }

  SUMMARY_TYPES[:personal] = {
    from_email: "updates@imgraetzl.at",
    from_name: "imGrätzl.at | Updates",
    blocks: [
      {
        name: 'New Topic in Group',
        types: [Notifications::NewGroupDiscussion]
      },
      {
        name: 'New Group Members',
        types: [Notifications::NewGroupUser]
      },
      {
        name: 'New Group Meeting',
        types: [Notifications::NewGroupMeeting]
      },
      {
        name: 'New Anwser in Topic I follow',
        types: [Notifications::NewGroupPost]
      },
      {
        name: "New Meeting Atendee",
        types: [Notifications::AttendeeInUsersMeeting]
      },
      {
        name: "New Meeting Updates",
        types: [Notifications::MeetingCancelled, Notifications::MeetingUpdated]
      },
      {
        name: "Comment on my content",
        types: [Notifications::CommentInMeeting, Notifications::CommentInUsersMeeting,
          Notifications::CommentOnAdminPost, Notifications::CommentOnLocationPost,
          Notifications::CommentOnRoomDemand, Notifications::CommentOnRoomOffer,
          Notifications::CommentOnUserPost
        ]
      },
      {
        name: 'Also commented',
        types: [Notifications::AlsoCommentedAdminPost, Notifications::AlsoCommentedLocationPost,
          Notifications::AlsoCommentedMeeting, Notifications::AlsoCommentedRoomDemand,
          Notifications::AlsoCommentedRoomOffer, Notifications::AlsoCommentedUserPost]
      },
      {
        name: 'Comment on my Wall',
        types: [Notifications::NewWallComment]
      },
    ]
  }

  def initialize(user, type, period)
    @user = user
    @period = period
    @type = type
  end

  def deliver
    if @period == :daily
      notifications = @user.pending_daily_notifications
    elsif @period == :weekly
      notifications = @user.pending_weekly_notifications
    else
      return
    end

    notification_types = SUMMARY_TYPES[@type][:blocks].map{|b| b[:types] }.flatten.map(&:to_s)
    notifications = notifications.where(type: notification_types)
    print "#{notifications.size} #{@period} #{@type} notifications found\n"
    return if notifications.empty?

    MandrillMailer.deliver(template: "summary-#{@type}-mail", message: {
      to: [ { email: @user.email } ],
      from_email: SUMMARY_TYPES[@type][:from_email],
      from_name: SUMMARY_TYPES[@type][:from_name],
      subject: mail_title,
      google_analytics_domains: ['staging.imgraetzl.at', 'www.imgraetzl.at'],
      google_analytics_campaign: 'summary-mail',
      global_merge_vars: message_vars(notifications),
    })

    notifications.update_all(sent: true)
  end

  private

  def message_vars(notifications)
    [
      { name: 'username', content: @user.username },
      { name: 'firstname', content: @user.first_name },
      { name: 'edit_user_url', content: edit_user_url(URL_OPTIONS) },
      { name: 'graetzl_name', content: @user.graetzl.name },
      { name: 'graetzl_url', content: graetzl_url(@user.graetzl, URL_OPTIONS) },
      { name: 'frequency_type', content: @period },
      { name: 'summary_type', content: @type },
      { name: 'notification_blocks', content: notification_block_vars(notifications) },
    ]
  end

  def notification_block_vars(notifications)
    block_mail_vars = []
    SUMMARY_TYPES[@type][:blocks].each do |block|
      block_notifications = notifications.select{|n| n.type.in?(block[:types].map(&:to_s))}
      if block_notifications.present?
        block_mail_vars << {
          name: block[:name],
          size: block_notifications.length,
          notifications: block_notifications.map(&:mail_vars)
        }
      end
    end
    block_mail_vars
  end

  def mail_title
    case @type
    when :graetzl
      "#{@user.graetzl.name} - Neue Treffen & Location Updates"
    when :rooms
      "#{@user.graetzl.name} - Neue Räume & Raumsuchende"
    when :personal
      "Persönliche Neuigkeiten für #{@user.first_name} zusammengefasst"
    end
  end

end
