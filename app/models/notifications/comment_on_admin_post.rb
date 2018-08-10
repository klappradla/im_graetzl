class Notifications::CommentOnAdminPost < Notification
  TRIGGER_KEY = 'admin_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.author_id)
  end

  def self.condition(activity)
    activity.trackable.author_id != activity.owner_id
  end

  def basic_mail_vars
    [
      { name: 'graetzl_name', content: user.graetzl.name },
      { name: 'graetzl_url', content: graetzl_url(user.graetzl, DEFAULT_URL_OPTIONS) }
    ]
  end

  def self.description
    'Meine erstellten Inhalte wurden kommentiert'
  end

  def custom_mail_vars
    {
      post_title: activity.trackable.content.truncate(50, separator: ' '),
      post_url: admin_post_url(activity.trackable, DEFAULT_URL_OPTIONS),
      headline: 'Neuer Kommentar bei deinem Beitrag:',
      title: activity.trackable.content.truncate(50, separator: ' '),
      url: admin_post_url(activity.trackable, DEFAULT_URL_OPTIONS),
      comment_url: admin_post_url(activity.trackable, DEFAULT_URL_OPTIONS),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    "#{activity.owner.username} hat deinen Beitrag kommentiert."
  end
end
