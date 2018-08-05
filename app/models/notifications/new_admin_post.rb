class Notifications::NewAdminPost < Notification
  TRIGGER_KEY = 'admin_post.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**2

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_ids)
  end

  def self.description
    'Es gibt einen neuen Admin Beitrag im Grätzl'
  end

  def basic_mail_vars
    [
      { name: 'graetzl_name', content: user.graetzl.name },
      { name: 'graetzl_url', content: graetzl_url(user.graetzl, DEFAULT_URL_OPTIONS) }
    ]
  end

  def custom_mail_vars
    {
      post_title: activity.trackable.title,
      post_content: activity.trackable.content.truncate(255, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.trackable.author),
      post_url: admin_post_url(activity.trackable, DEFAULT_URL_OPTIONS)
    }
  end

  def mail_subject
    "Neuer Admin Beitrag"
  end
end
