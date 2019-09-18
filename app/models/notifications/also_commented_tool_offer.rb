class Notifications::AlsoCommentedToolOffer < Notification
  TRIGGER_KEY = 'tool_offer.comment'
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
    "#{activity.owner.username} hat einen Toolteiler ebenfalls kommentiert."
  end

  def headline
    'Neuer Kommentar bei einem Toolteiler'
  end

  def content_title
    tool_offer.title
  end

  def content_url_params
    tool_offer
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    tool_offer
  end

  private

  def tool_offer
    activity.trackable
  end

end
