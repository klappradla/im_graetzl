class Notifications::CommentOnUserPost < Notification
  TRIGGER_KEY = 'user_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.author_id)
  end

  def self.condition(activity)
    activity.trackable.author_type == 'User' && activity.trackable.author.present? && activity.trackable.author_id != activity.owner_id
  end

  def self.description
    'Meine erstellten Inhalte wurden kommentiert'
  end

  def custom_mail_vars
    {
      post_title: activity.trackable.content.truncate(50, separator: ' '),
      post_url: graetzl_user_post_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      comment_url: graetzl_user_post_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    'Neuer Kommentar auf deinen Beitrag'
  end
end
