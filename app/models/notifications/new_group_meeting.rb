class Notifications::NewGroupMeeting < Notification
  TRIGGER_KEY = 'meeting.create'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**17

  def self.receivers(activity)
    if activity.trackable.group_id?
      activity.trackable.group.users
    else
      []
    end
  end

  def self.description
    'Eine neues Treffen wurde in der Gruppe erstellt.'
  end

  def custom_mail_vars
    {
      group_name: activity.trackable.group.title,
      owner_name: activity.owner.username,
      owner_firstname: activity.owner.first_name,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
      meeting_name: activity.trackable.name,
      meeting_description: activity.trackable.description.truncate(255, separator: ' '),
      meeting_url: graetzl_meeting_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      meeting_date: activity.trackable.starts_at_date ? I18n.localize(activity.trackable.starts_at_date, format:'%A %d. %B') : '',
      cover_photo_url: Notifications::ImageService.new.cover_photo_url(activity.trackable),
    }
  end

  def mail_subject
    "Neues Gruppentreffen von #{activity.owner.first_name} in der Gruppe #{activity.trackable.group.title}"
  end

  private

  def set_notify_time
    # Send meeting notifications 7 days before the meeting date, or immediately if the meeting is in
    # less than 7 days. Also make sure not to send notification after the meeting has happened.
    if activity.trackable.starts_at_date.present?
      self.notify_at = activity.trackable.starts_at_date - 7.days
      self.notify_at = Time.current if self.notify_at.past?
      self.notify_before = activity.trackable.starts_at_date
    else
      self.notify_at = Time.current
      self.notify_before = nil
    end
  end

end
