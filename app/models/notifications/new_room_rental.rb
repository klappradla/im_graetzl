class Notifications::NewRoomRental < Notification
  TRIGGER_KEY = 'room_rental.create'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.room_offer.user.id)
  end

  def self.description
    'Neue Toolteiler Anfrage'
  end

  def room_rental
    activity.trackable
  end
end
