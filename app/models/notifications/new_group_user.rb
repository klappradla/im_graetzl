class Notifications::NewGroupUser < Notification
  TRIGGER_KEY = 'group_user.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**16

  def self.receivers(activity)
    activity.trackable.group.users - [activity.trackable.user]
  end

  def self.description
    'Ein neues Mitglied ist der Gruppe beigetreten.'
  end

  def mail_subject
    "Neues Mitglied in der Gruppe #{group.title}"
  end

  def group
    group_user.group
  end

  def group_user
    activity.trackable
  end

end
