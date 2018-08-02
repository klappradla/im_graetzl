class Notifications::NewGroupDiscussion < Notification
  TRIGGER_KEY = 'discussion.create'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**15

  def self.receivers(activity)
    activity.trackable.group.users
  end

  def self.description
    'Eine neue Diskussion wurde gestartet.'
  end

  def mail_vars
    {
      group_name: activity.trackable.group.title,
      discussion_title: activity.trackable.title,
      first_post_content: activity.trackable.discussion_posts.first.content.truncate(300, separator: ' '),
      discussion_url: group_discussion_path(activity.trackable.group, activity.trackable),
      owner_firstname: activity.owner.first_name,
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable.user).call
    }
  end

  def mail_subject
    'Eine neue Diskussion wurde gestartet.'
  end

end
