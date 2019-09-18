class Notifications::CommentOnRoomDemand < Notification
  TRIGGER_KEY = 'room_demand.comment'
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
    "#{activity.owner.username} hat dein Raumgesuch kommentiert."
  end

  def headline
    'Neuer Kommentar bei deinem Raumteiler'
  end

  def content_title
    room_demand.slogan
  end

  def content_url_params
    room_demand
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    room_demand
  end

  private

  def room_demand
    activity.trackable
  end

end
