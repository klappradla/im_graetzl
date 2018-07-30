class Notifications::NewRoomDemand < Notification
  TRIGGER_KEY = 'room_demand.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**13

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_ids)
  end

  def self.description
    'Eine neue Raumsuche wurde im Grätzl veröffentlicht'
  end

  def self.notify_owner?
    true
  end

  def mail_vars
    {
      type: type.demodulize.underscore,
      room_title: activity.trackable.slogan,
      room_url: room_demand_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_type: I18n.t("activerecord.attributes.room_demand.demand_types_active.#{activity.trackable.demand_type}"),
      room_description: activity.trackable.demand_description.truncate(255, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable).call
    }
  end

  def mail_subject
    "#{activity.owner.username} sucht Räumlichkeiten"
  end
end
