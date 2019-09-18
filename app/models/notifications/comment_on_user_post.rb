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

  def mail_template
    "commented"
  end

  def mail_subject
    "#{activity.owner.username} hat deinen Beitrag kommentiert."
  end

  def headline
    'Neuer Kommentar bei deinem Beitrag'
  end

  def content_title
    user_post.title
  end

  def content_url_params
    [user_post.graetzl, user_post]
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    [user_post.graetzl, user_post]
  end

  private

  def user_post
    activity.trackable
  end

end
