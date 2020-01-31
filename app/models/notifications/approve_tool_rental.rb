class Notifications::ApproveToolRental < Notification
  TRIGGER_KEY = 'tool_rental.approve'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    'Deine Toolteiler Anfrage wurde bestätigt'
  end

  def tool_rental
    activity.trackable
  end
end
