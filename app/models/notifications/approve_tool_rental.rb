class Notifications::ApproveToolRental < Notification
  TRIGGER_KEY = 'tool_rental.approve'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**4

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
