class Notifications::NewUserPost < Notification
  TRIGGER_KEY = 'user_post.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**2

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Es gibt eine neue Idee im Grätzl'
  end

  def self.notify_owner?
    true
  end

  def mail_subject
    "Neue Idee im Grätzl #{user_post.graetzl.name}"
  end

  def user_post
    activity.trackable
  end

end
