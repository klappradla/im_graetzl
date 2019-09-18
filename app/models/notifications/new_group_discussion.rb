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

  def mail_subject
    "Neues Thema von #{activity.owner.first_name} in der Gruppe #{group.title}."
  end

  def discussion
    activity.trackable
  end

  def group
    discussion.group
  end

  def initial_post
    discussion.discussion_posts.first
  end

end
