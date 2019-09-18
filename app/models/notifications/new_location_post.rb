class Notifications::NewLocationPost < Notification
  TRIGGER_KEY = 'location_post.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**1

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Eine Location aus deinem Grätzl hat eine Neuigkeit erstellt'
  end

  def self.notify_owner?
    true
  end

  def mail_subject
    "Neuer Beitrag im Grätzl #{activity.trackable.graetzl.name}"
  end

  def location_post
    activity.trackable
  end

  def location
    location_post.author
  end

end
