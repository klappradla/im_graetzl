class Notifications::NewGroup < Notification
  TRIGGER_KEY = 'group.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**7

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_ids)
  end

  def self.description
    'Eine neue Gruppe wurde im Grätzl erstellt'
  end

  def custom_mail_vars
    {
      group_name: activity.trackable.title,
      group_description: activity.trackable.description.truncate(255, separator: ' '),
      group_url: group_url(activity.trackable),
      owner_name: activity.owner.full_name,
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
      cover_photo_url: Notifications::ImageService.new.cover_photo_url(activity.trackable),
    }
  end

  def mail_subject
    "Neue Gruppe von #{activity.owner.full_name}."
  end

end
