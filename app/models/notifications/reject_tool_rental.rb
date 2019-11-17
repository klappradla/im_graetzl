class Notifications::RejectToolRental < Notification
  TRIGGER_KEY = 'tool_rental.reject'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**4

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
