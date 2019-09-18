class Notifications::CommentOnToolOffer < Notification
  TRIGGER_KEY = 'tool_offer.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    "Meine erstellten Inhalte wurden kommentiert"
  end

  def mail_template
    "commented"
  end

  def mail_subject
    "#{activity.owner.username} hat deinen Toolteiler kommentiert."
  end

  def headline
    'Neuer Kommentar bei deinem Toolteiler'
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
