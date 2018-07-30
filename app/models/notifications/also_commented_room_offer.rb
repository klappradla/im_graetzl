class Notifications::AlsoCommentedRoomOffer < Notification
  TRIGGER_KEY = 'room_offer.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**6

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    'Es gibt neue Antworten auf Inhalte die ich auch kommentiert habe'
  end

  def mail_vars
    {
      room_title: activity.trackable.slogan,
      room_url: room_offer_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_type: I18n.t("activerecord.attributes.room_offer.offer_types_active.#{activity.trackable.offer_type}"),
      room_description: activity.trackable.room_description,
      comment_url: room_offer_url(activity.trackable, DEFAULT_URL_OPTIONS),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::AvatarService.new(activity.owner).call
    }
  end

  def mail_subject
    'Neue Antwort bei Raumteiler'
  end
end
