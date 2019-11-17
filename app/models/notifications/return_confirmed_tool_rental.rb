class Notifications::ReturnConfirmedToolRental < Notification
  TRIGGER_KEY = 'tool_rental.return_confirmed'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    'Toolteiler Rückgabe bestätigt. Verleihvorgang bewerten.'
  end

  def tool_rental
    activity.trackable
  end
end
