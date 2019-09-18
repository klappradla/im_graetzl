class Notifications::AlsoCommentedRoomDemand < Notification
  TRIGGER_KEY = 'room_demand.comment'
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
    "#{activity.owner.username} hat ein Raumgesuch ebenfalls kommentiert."
  end

  def headline
    'Neuer Kommentar bei einer Raumsuche'
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
