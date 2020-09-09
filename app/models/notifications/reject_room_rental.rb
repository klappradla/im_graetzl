class Notifications::RejectRoomRental < Notification
  TRIGGER_KEY = 'room_rental.reject'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    'Raumteiler Anfrage wurde abgelehnt'
  end

  def room_rental
    activity.trackable
  end
end
