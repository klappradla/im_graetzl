class Notifications::NewAdminPost < Notification
  TRIGGER_KEY = 'admin_post.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**2

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_ids)
  end

  def self.description
    'Es gibt einen neuen Admin Beitrag im Grätzl'
  end

  def mail_subject
    "Neuer Admin Beitrag"
  end

  def admin_post
    activity.trackable
  end
end
