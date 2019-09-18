class Notifications::AlsoCommentedLocationPost < Notification
  TRIGGER_KEY = 'location_post.comment'
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
    'Neuer Kommentar bei Location-Update'
  end

  def content_title
    location_post.title
  end

  def content_url_params
    [location.graetzl, location]
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    [location.graetzl, location]
  end

  private

  def location_post
    activity.trackable
  end

  def location
    location_post.author
  end
end
