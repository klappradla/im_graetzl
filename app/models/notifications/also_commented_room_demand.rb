class Notifications::AlsoCommentedRoomDemand < Notification
  TRIGGER_KEY = 'room_demand.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**6

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    'Es gibt neue Antworten auf Inhalte die ich auch kommentiert habe'
  end

  def custom_mail_vars
    {
      #room_title: activity.trackable.slogan,
      #room_url: room_demand_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_type: I18n.t("activerecord.attributes.room_demand.demand_types_active.#{activity.trackable.demand_type}"),
      room_description: activity.trackable.demand_description,
      type: 'also_commented',
      headline: 'Neuer Kommentar bei Raumsuche:',
      title: activity.trackable.slogan,
      url: room_demand_url(activity.trackable, DEFAULT_URL_OPTIONS),
      comment_url: room_demand_url(activity.trackable, DEFAULT_URL_OPTIONS),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    "#{activity.owner.username} hat ein Raumgesuch ebenfalls kommentiert."
  end
end
