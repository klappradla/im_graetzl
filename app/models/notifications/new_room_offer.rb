class Notifications::NewRoomOffer < Notification
  TRIGGER_KEY = 'room_offer.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**12

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Ein neues Raumangebot wurde im Grätzl erstellt'
  end

  def self.notify_owner?
    true
  end

  def mail_vars
    {
      type: type.demodulize.underscore,
      room_title: activity.trackable.slogan,
      room_url: room_offer_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_type: I18n.t("activerecord.attributes.room_offer.offer_types_active.#{activity.trackable.offer_type}"),
      room_description: activity.trackable.room_description.truncate(255, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable).call,
    }
  end

  def mail_subject
    "Neuer Raumteiler im Grätzl #{activity.trackable.graetzl.name}"
  end
end
