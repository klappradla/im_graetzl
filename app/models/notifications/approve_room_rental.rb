class Notifications::ApproveRoomRental < Notification
  TRIGGER_KEY = 'room_rental.approve'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    'Deine Raumteiler Anfrage wurde bestätigt'
  end

  def room_rental
    activity.trackable
  end
end
