class Notifications::NewRoomCall < Notification
  TRIGGER_KEY = 'room_call.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**14

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id) # User.all
  end

  def self.description
    'Eine gibt einen neuen Raumteiler Call'
  end

  def self.notify_owner?
    true
  end

  def mail_vars
    {
      room_title: activity.trackable.title,
      room_url: room_call_url(activity.trackable, DEFAULT_URL_OPTIONS),
      room_description: activity.trackable.description.truncate(255, separator: ' '),
      room_call_starts_at: activity.trackable.starts_at,
      room_call_ends_at: activity.trackable.ends_at,
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable).call
    }
  end

  def mail_subject
    "#{activity.owner.username} hat einen neuen Call gestartet."
  end

  private

  def set_notify_at
    reminder_date = activity.trackable.starts_at - 7.days
    if reminder_date.past?
      self.notify_at = Time.current
    else
      self.notify_at = reminder_date
    end
  end
end
