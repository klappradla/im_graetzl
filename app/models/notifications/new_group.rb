class Notifications::NewGroup < Notification
  TRIGGER_KEY = 'group.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**7

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_ids)
  end

  def self.description
    'Es gibt eine neue Gruppe im Grätzl'
  end

  def mail_subject
    "Neue Gruppe von #{activity.owner.full_name}."
  end

  def group
    activity.trackable
  end

end
