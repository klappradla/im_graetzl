class Notifications::NewToolOffer < Notification
  TRIGGER_KEY = 'tool_offer.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**19

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Ein neuer Toolteiler wurde im Grätzl erstellt'
  end

  def self.notify_owner?
    true
  end

  def mail_subject
    "Neuer Toolteiler im Grätzl #{activity.trackable.graetzl.name}"
  end

  def tool_offer
    activity.trackable
  end

end
