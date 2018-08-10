class Notifications::AlsoCommentedUserPost < Notification
  TRIGGER_KEY = 'user_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**6

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    'Es gibt neue Antworten auf Inhalte die ich auch kommentiert habe'
  end

  def custom_mail_vars
    {
      #post_title: activity.trackable.title,
      #post_url: graetzl_user_post_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      type: 'also_commented',
      headline: 'Neuer Kommentar bei Beitrag:',
      title: activity.trackable.title,
      url: graetzl_user_post_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      comment_url: graetzl_user_post_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    "#{activity.owner.username} hat einen Beitrag ebenfalls kommentiert."
  end
end
