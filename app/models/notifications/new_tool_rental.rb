class Notifications::NewToolRental < Notification
  TRIGGER_KEY = 'tool_rental.create'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.tool_offer.user.id)
  end

  def self.description
    'Neue Toolteiler Anfrage'
  end

  def tool_rental
    activity.trackable
  end
end
