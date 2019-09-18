class Notifications::NewWallComment < Notification
  TRIGGER_KEY = 'user.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**10

  def self.receivers(activity)
    User.where(id: activity.trackable.id)
  end

  def self.condition(activity)
    activity.owner.present? && activity.recipient.present?
  end

  def self.description
    'Jemand hat auf meine Pinnwand geschrieben'
  end

  def mail_subject
    "#{activity.owner.username} hat auf deine Pinnwand geschrieben."
  end

  def comment
    activity.recipient
  end

end
