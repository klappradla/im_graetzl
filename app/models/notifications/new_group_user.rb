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

  def custom_mail_vars
    {
      group_name: group.title,
      group_url: group_url(group, DEFAULT_URL_OPTIONS, anchor: 'tab-members'),
      group_user_first_name: activity.trackable.user.first_name,
      group_user_last_name: activity.trackable.user.last_name,
      group_user_url: user_url(activity.trackable.user, DEFAULT_URL_OPTIONS),
      group_user_avatar_url: Notifications::ImageService.new.avatar_url(activity.trackable.user),
    }
  end

  def mail_subject
    "Neues Mitglied in der Gruppe #{group.title}"
  end

  def group
    activity.trackable.group
  end

end
