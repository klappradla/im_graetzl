class Notifications::ReturnPendingToolRental < Notification
  TRIGGER_KEY = 'tool_rental.return_pending'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.tool_offer.user.id)
  end

  def self.description
    'Toolteiler Rückgabe Bestätigung'
  end

  def tool_rental
    activity.trackable
  end
end
