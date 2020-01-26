class Notifications::MeetingUpdated < Notification
  TRIGGER_KEY = 'meeting.update'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**3

  def self.receivers(activity)
    activity.trackable.users
  end

  def self.description
    'Änderungen eines Treffens an dem ich interessiert bin'
  end

  def mail_subject
    'Es gibt Änderungen bei einem Treffen an dem du interessiert bist'
  end

  def meeting
    activity.trackable
  end

end
