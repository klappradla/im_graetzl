class Notifications::ReturnPendingToolRental < Notification
  TRIGGER_KEY = 'tool_rental.return_pending'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**4

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
