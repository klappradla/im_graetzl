class Notification::SummaryMail
  include MailUtils

  SUMMARY_TYPES = {}
  SUMMARY_TYPES[:graetzl] = {
    from_email: "neuigkeiten@imgraetzl.at",
    from_name: "imGrätzl.at | Neuigkeiten",
    blocks: [
      {
        name: 'Neue Locations in deinem Grätzl',
        types: [Notifications::NewLocation].map(&:to_s)
      },
      {
        name: 'Neue Treffen',
        types: [Notifications::NewMeeting].map(&:to_s)
      },
      {
        name: 'Neue Location Updates',
        types: [Notifications::NewLocationPost].map(&:to_s)
      },
      {
        name: 'Neue Ideen im Grätzl',
        types: [Notifications::NewUserPost, Notifications::NewAdminPost].map(&:to_s)
      },
      {
        name: 'Neue Gruppen',
        types: [Notifications::NewGroup].map(&:to_s)
      },
    ]
  }

  SUMMARY_TYPES[:rooms] = {
    from_email: "raumteiler@imgraetzl.at",
    from_name: "imGrätzl.at | Raumteiler",
    blocks: [
      {
        name: 'Neuer Raumteiler Call',
        types: [Notifications::NewRoomCall].map(&:to_s)
      },
      {
        name: 'Neue Räume zum Andocken',
        types: [Notifications::NewRoomOffer].map(&:to_s)
      },
      {
        name: 'Auf der Suche nach Raum',
        types: [Notifications::NewRoomDemand].map(&:to_s)
      },
    ]
  }

  SUMMARY_TYPES[:personal] = {
    from_email: "updates@imgraetzl.at",
    from_name: "imGrätzl.at | Updates",
    blocks: [
      {
        name: 'Gruppe: ',
        types: [
          Notifications::NewGroupMeeting,
          Notifications::NewGroupDiscussion,
          Notifications::NewGroupPost,
          Notifications::NewGroupUser,
          Notifications::CommentOnDiscussionPost,
          Notifications::AlsoCommentedDiscussionPost,
        ].map(&:to_s),
        group: true,
      },
      {
        name: "Neuer Teilnehmer bei einem Treffen",
        types: [Notifications::AttendeeInUsersMeeting].map(&:to_s)
      },
      {
        name: "Änderungen in einem Treffen",
        types: [Notifications::MeetingCancelled, Notifications::MeetingUpdated].map(&:to_s)
      },
      {
        name: "Neuer Kommentar bei",
        types: [Notifications::CommentInMeeting, Notifications::CommentInUsersMeeting,
          Notifications::CommentOnAdminPost, Notifications::CommentOnLocationPost,
          Notifications::CommentOnRoomDemand, Notifications::CommentOnRoomOffer,
          Notifications::CommentOnUserPost
        ].map(&:to_s)
      },
      {
        name: 'Ebenfalls kommentiert',
        types: [Notifications::AlsoCommentedAdminPost, Notifications::AlsoCommentedLocationPost,
          Notifications::AlsoCommentedMeeting, Notifications::AlsoCommentedRoomDemand,
          Notifications::AlsoCommentedRoomOffer, Notifications::AlsoCommentedUserPost
        ].map(&:to_s)
      },
      {
        name: 'Neuer Kommentar auf deiner Pinnwand',
        types: [Notifications::NewWallComment].map(&:to_s)
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

    notification_types = SUMMARY_TYPES[@type][:blocks].map{|b| b[:types] }.flatten
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
    notifications = notifications.select{|n| n.type.in?(block[:types])}
    return [] if notifications.blank?
    notification_vars = notifications.map(&:mail_vars)
    [{
      name: block[:name],
      size: notifications.length,
      notifications: notification_vars
    }]
  end

  def generate_group_block(block, notifications)
    notifications = notifications.select{|n| n.type.in?(block[:types])}
    return [] if notifications.blank?
    notifications.group_by(&:group).map do |group, group_notifications|
      post_notifications, other_notifications = group_notifications.partition{|n| n.type == "Notifications::NewGroupPost"}
      comment_notifications, other_notifications = other_notifications.partition{|n| n.type == "Notifications::CommentOnDiscussionPost"}
      also_commented_notifications, other_notifications = other_notifications.partition{|n| n.type == "Notifications::AlsoCommentedDiscussionPost"}
      members_notifications, other_notifications = other_notifications.partition{|n| n.type == "Notifications::NewGroupUser"}
      # Sort by type
      notification_vars = other_notifications.sort_by{|n| block[:types].index(n.type) }.map(&:mail_vars)

      # Mark members in group
      members_notifications.first[:first_in_group] = 'true'
      members_notifications.last[:last_in_group] = 'true'
      notification_vars += members_notifications

      # Group discussion posts by discussion
      post_notifications.group_by(&:group_discussion_id).values.each do |discussion_notifications|
        discussion_vars = discussion_notifications.sort_by(&:created_at).map(&:mail_vars)
        discussion_vars.each_with_index{|d, i| d[:first_in_discussion] = i.zero? ? 'true' : 'false'}
        discussion_vars.reverse.each_with_index{|d, i| d[:last_in_discussion] = i.zero? ? 'true' : 'false'}
        notification_vars += discussion_vars
      end
      # Group comments by discussion post
      comment_notifications.group_by(&:group_discussion_post_id).values.each do |comment_notifications|
        comment_vars = comment_notifications.sort_by(&:created_at).map(&:mail_vars)
        comment_vars.each_with_index{|d, i| d[:first_in_post] = i.zero? ? 'true' : 'false'}
        comment_vars.reverse.each_with_index{|d, i| d[:last_in_post] = i.zero? ? 'true' : 'false'}
        notification_vars += comment_vars
      end
      # Group also commented by discussion post
      also_commented_notifications.group_by(&:group_discussion_post_id).values.each do |comment_notifications|
        also_commented_vars = comment_notifications.sort_by(&:created_at).map(&:mail_vars)
        also_commented_vars.each_with_index{|d, i| d[:first_in_post] = i.zero? ? 'true' : 'false'}
        also_commented_vars.reverse.each_with_index{|d, i| d[:last_in_post] = i.zero? ? 'true' : 'false'}
        notification_vars += also_commented_vars
      end
      {
        name: "#{block[:name]} „#{group.title}“",
        size: group_notifications.length,
        notifications: notification_vars,
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
