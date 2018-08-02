class Notifications::NewGroupPost < Notification
  TRIGGER_KEY = 'discussion_post.create'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**18

  def self.receivers(activity)
    activity.trackable.discussion.following_users
  end

  def self.description
    'Es gibt neue Antworten in Diskussionen denen ich folge'
  end

  def mail_vars
    {
      group_name: activity.trackable.group.title,
      discussion_title: activity.trackable.discussion.title,
      discussion_url: group_discussion_path(activity.trackable.group, activity.trackable.discussion),
      post_content: activity.trackable.content.truncate(300, separator: ' '),
      owner_firstname: activity.owner.first_name,
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable.user).call,
    }
  end

  def mail_subject
    "Neue Antwort von #{activity.owner.first_name} im Thema #{activity.trackable.discussion.title}."
  end

end
