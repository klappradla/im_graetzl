class Notifications::NewGroupPost < Notification
  TRIGGER_KEY = 'discussion_post.create'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**18

  def self.receivers(activity)
    activity.trackable.discussion.following_users
  end

  def self.description
    'Es gibt neue Antworten in Themen denen ich folge'
  end

  def mail_subject
    "Neue Antwort von #{activity.owner.first_name} im Thema #{activity.trackable.discussion.title}."
  end

  def group
    discussion_post.group
  end

  def discussion
    discussion_post.discussion
  end

  def discussion_post
    activity.trackable
  end

end
