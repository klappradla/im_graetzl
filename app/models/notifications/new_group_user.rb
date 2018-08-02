class Notifications::NewGroupUser < Notification
  TRIGGER_KEY = 'group_user.create'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**16

  def self.receivers(activity)
    activity.trackable.group.users
  end

  def self.description
    'Ein neues Mitglied ist der Gruppe beigetreten.'
  end

  def mail_vars
    {
      group_name: activity.trackable.group.title,
      group_user_first_name: activity.trackable.user.name,
      group_user_last_name: activity.trackable.user.last_name,
      group_user_avatar_url: Notifications::AvatarService.new(activity.trackable.user).call,
    }
  end

  def mail_subject
    'Ein neues Mitglied ist der Gruppe beigetreten.'
  end

end
