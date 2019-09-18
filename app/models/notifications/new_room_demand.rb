class Notifications::NewRoomDemand < Notification
  TRIGGER_KEY = 'room_demand.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**13

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_ids)
  end

  def self.description
    'Eine neue Raumsuche wurde im Grätzl veröffentlicht'
  end

  def self.notify_owner?
    true
  end

  def mail_subject
    "#{activity.owner.username} sucht Räumlichkeiten"
  end

  def room_demand
    activity.trackable
  end
end
