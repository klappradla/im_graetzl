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

  def mail_vars
    {
      type: type.demodulize.underscore,
      post_title: activity.trackable.title,
      post_content: activity.trackable.content.truncate(255, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable.author).call,
      post_url: graetzl_user_post_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS)
    }
  end

  def mail_subject
    "Neue Idee im Grätzl #{activity.trackable.graetzl.name}"
  end
end
