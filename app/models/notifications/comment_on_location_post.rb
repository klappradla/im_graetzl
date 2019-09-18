class Notifications::CommentOnLocationPost < Notification
  TRIGGER_KEY = 'location_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    activity.trackable.author.users
  end

  def self.condition(activity)
    activity.trackable.author.present? && activity.trackable.author_type == "Location" && activity.trackable.author.users.exclude?(activity.owner)
  end

  def self.description
    "Meine erstellten Inhalte wurden kommentiert"
  end

  def mail_template
    "commented"
  end

  def mail_subject
    "#{activity.owner.username} hat dein Location-Update kommentiert."
  end

  def headline
    'Neuer Kommentar bei deinem Location-Update'
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
