class Notifications::NewMeeting < Notification
  TRIGGER_KEY = 'meeting.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**0

  def self.receivers(activity)
    if activity.trackable.public?
      User.where(graetzl_id: activity.trackable.graetzl_id)
    else
      []
    end
  end

  def self.description
    'Ein neues Treffen wurde im Grätzl erstellt'
  end

  def self.notify_owner?
    true
  end

  def custom_mail_vars
    {
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
      meeting_name: activity.trackable.name.truncate(70, separator: ' '),
      meeting_url: graetzl_meeting_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      meeting_starts_at: (activity.trackable.starts_at_date && activity.trackable.starts_at_time) ? "#{I18n.localize(activity.trackable.starts_at_date, format:'%A %d. %B')}, #{I18n.localize(activity.trackable.starts_at_time, format:'%H:%M')} Uhr" : '',
      meeting_starts_at_date: activity.trackable.starts_at_date ? I18n.localize(activity.trackable.starts_at_date, format:'%A %d. %B') : '',
      meeting_starts_at_time: activity.trackable.starts_at_time ? I18n.localize(activity.trackable.starts_at_time, format:'%H:%M') : '',
      meeting_starts_at_day: activity.trackable.starts_at_date ? I18n.localize(activity.trackable.starts_at_date, format:'%d.') : '',
      meeting_starts_at_month: activity.trackable.starts_at_date ? I18n.localize(activity.trackable.starts_at_date, format:'%b') : '',
      meeting_description: activity.trackable.description.truncate(255, separator: ' '),
      cover_photo_url: Notifications::ImageService.new.cover_photo_url(activity.trackable),
    }
  end

  def mail_subject
    "Neues Treffen im Grätzl #{activity.trackable.graetzl.name}"
  end

  private

  def set_notify_at
    reminder_date = activity.trackable.starts_at_date - 7.days
    if reminder_date.past?
      self.notify_at = Time.current
    else
      self.notify_at = reminder_date
    end
  end

end
