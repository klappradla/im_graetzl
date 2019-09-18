class Notifications::AlsoCommentedAdminPost < Notification
  TRIGGER_KEY = 'admin_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**6

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    'Es gibt neue Antworten auf Inhalte die ich auch kommentiert habe'
  end

  def mail_template
    "also_commented"
  end

  def mail_subject
    "#{activity.owner.username} hat einen Beitrag ebenfalls kommentiert."
  end

  def headline
    'Neuer Kommentar bei einem Beitrag'
  end

  def content_title
    admin_post.title
  end

  def content_url_params
    admin_post
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    admin_post
  end

  private

  def admin_post
    activity.trackable
  end

end
