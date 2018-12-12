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
      {
        name: 'Neue Gruppen im Grätzl',
        types: [Notifications::NewGroup]
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
        name: 'Neue in der Gruppe',
        group: true,
      },
      {
        name: "Neuer Teilnehmer bei einem Treffen",
        types: [Notifications::AttendeeInUsersMeeting]
      },
      {
        name: "Änderungen in einem Treffen",
        types: [Notifications::MeetingCancelled, Notifications::MeetingUpdated]
      },
      {
        name: "Neuer Kommentar bei",
        types: [Notifications::CommentInMeeting, Notifications::CommentInUsersMeeting,
          Notifications::CommentOnAdminPost, Notifications::CommentOnLocationPost,
          Notifications::CommentOnRoomDemand, Notifications::CommentOnRoomOffer,
          Notifications::CommentOnUserPost
        ]
      },
      {
        name: 'Ebenfalls kommentiert',
        types: [Notifications::AlsoCommentedAdminPost, Notifications::AlsoCommentedLocationPost,
          Notifications::AlsoCommentedMeeting, Notifications::AlsoCommentedRoomDemand,
          Notifications::AlsoCommentedRoomOffer, Notifications::AlsoCommentedUserPost]
      },
      {
        name: 'Neuer Kommentar auf deiner Pinnwand',
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
    block_vars = []
    SUMMARY_TYPES[@type][:blocks].each do |block|
      if block[:group]
        block_vars += generate_group_block(block, notifications)
      else
        block_vars += generate_basic_block(block, notifications)
      end
    end
    block_vars
  end

  def generate_basic_block(block, notifications)
    notifications = notifications.select{|n| n.type.in?(block[:types].map(&:to_s))}
    return [] if notifications.blank?
    [{
      name: block[:name],
      size: notifications.length,
      notifications: notifications.map(&:mail_vars)
    }]
  end

  GROUP_NOTIFICATIONS = [
    Notifications::NewGroupDiscussion,
    Notifications::NewGroupUser,
    Notifications::NewGroupMeeting,
    Notifications::NewGroupPost,
  ].map(&:to_s)

  def generate_group_block(block, notifications)
    notifications = notifications.select{|n| n.type.in?(GROUP_NOTIFICATIONS)}
    return [] if notifications.blank?
    notifications.group_by(&:group).map do |group, group_notifications|
      # Sort by: type, discussion, date
      group_notifications.sort_by!{|gn| [GROUP_NOTIFICATIONS.index(gn.type), gn.try(:group_discussion_id), gn.created_at]}
      {
        name: "#{block[:name]} #{group.title}",
        size: group_notifications.length,
        notifications: group_notifications.map(&:mail_vars)
      }
    end
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
