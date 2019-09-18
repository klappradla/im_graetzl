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

  def mail_subject
    "Neues Treffen im Grätzl #{meeting.graetzl.name}"
  end

  def meeting
    activity.trackable
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
