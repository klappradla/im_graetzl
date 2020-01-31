class Notifications::CancelToolRental < Notification
  TRIGGER_KEY = 'tool_rental.cancel'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.tool_offer.user.id)
  end

  def self.description
    'Toolteiler Anfrage wurde zurückgezogen'
  end

  def tool_rental
    activity.trackable
  end
end
