class Notifications::NewRoomCall < Notification
  TRIGGER_KEY = 'room_call.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**14

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Eine gibt einen neuen Raumteiler Call'
  end

  def self.notify_owner?
    true
  end

  def custom_mail_vars
    {
      room_title: activity.trackable.title,
      room_url: room_call_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_description: activity.trackable.description.truncate(255, separator: ' '),
      room_call_starts_at: activity.trackable.starts_at,
      room_call_ends_at: activity.trackable.ends_at,
      cover_photo_url: Notifications::ImageService.new.cover_photo_url(activity.trackable),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.trackable),
    }
  end

  def mail_subject
    "#{activity.owner.username} hat einen neuen Call gestartet."
  end

  private

  def set_notify_time
    # Send room call notifications 7 days before the start date, or immediately if it starts in
    # less than 7 days.
    if activity.trackable.starts_at.present?
      self.notify_at = activity.trackable.starts_at - 7.days
      self.notify_at = Time.current if self.notify_at.past?
    else
      self.notify_at = Time.current
    end
  end
end
