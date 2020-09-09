class Notifications::CancelRoomRental < Notification
  TRIGGER_KEY = 'room_rental.cancel'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.room_offer.user.id)
  end

  def self.description
    'Raumteiler Anfrage wurde zurückgezogen'
  end

  def room_rental
    activity.trackable
  end
end
