class Notifications::NewRoomOffer < Notification
  TRIGGER_KEY = 'room_offer.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**12

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Ein neues Raumangebot wurde im Grätzl erstellt'
  end

  def self.notify_owner?
    true
  end

  def mail_subject
    "Neuer Raumteiler im Grätzl #{activity.trackable.graetzl.name}"
  end

  def room_offer
    activity.trackable
  end

end
