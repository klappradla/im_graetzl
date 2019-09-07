class Notifications::NewToolOffer < Notification
  TRIGGER_KEY = 'tool_offer.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**19

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Ein neuer Toolteiler wurde im Grätzl erstellt'
  end

  def self.notify_owner?
    true
  end

  def custom_mail_vars
    {
      tool_title: activity.trackable.title.truncate(70, separator: ' '),
      tool_offer_url: tool_offer_url(activity.trackable, DEFAULT_URL_OPTIONS),
      tool_offer_description: activity.trackable.description.truncate(255, separator: ' '),
      cover_photo_url: Notifications::ImageService.new.cover_photo_url(activity.trackable),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.trackable),
    }
  end

  def mail_subject
    "Neuer Toolteiler im Grätzl #{activity.trackable.graetzl.name}"
  end
end
