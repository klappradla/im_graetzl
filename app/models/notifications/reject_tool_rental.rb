class Notifications::RejectToolRental < Notification
  TRIGGER_KEY = 'tool_rental.reject'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    'Toolteiler Anfrage wurde abgelehnt'
  end

  def tool_rental
    activity.trackable
  end
end
