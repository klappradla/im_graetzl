class Notifications::CommentOnRoomOffer < Notification
  TRIGGER_KEY = 'room_offer.comment'
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
    "#{activity.owner.username} hat deinen Raum kommentiert."
  end

  def headline
    'Neuer Kommentar bei deinem Raumteiler'
  end

  def content_title
    room_offer.slogan
  end

  def content_url_params
    room_offer
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    room_offer
  end

  private

  def room_offer
    activity.trackable
  end

end
