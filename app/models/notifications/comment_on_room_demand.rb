class Notifications::CommentOnRoomDemand < Notification
  TRIGGER_KEY = 'room_demand.comment'
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    "Meine erstellten Inhalten wurden kommentiert"
  end

  def mail_vars
    {
      room_name: activity.trackable.slogan,
      room_url: room_demand_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_type: activity.trackable.demand_type,
      comment_url: room_demand_url(activity.trackable, DEFAULT_URL_OPTIONS),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::AvatarService.new(activity.owner).call
    }
  end

  def mail_subject
    "#{activity.owner.username} hat deinen Raumteiler kommentiert."
  end
end
