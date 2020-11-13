class Notifications::MeetingUpdated < Notification
  TRIGGER_KEY = 'meeting.update'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**3

  def self.receivers(activity)
    activity.trackable.users
  end

  def self.description
    'Änderungen eines Treffens an dem ich teilnehme'
  end

  def mail_subject
    'Es gibt Änderungen bei einem Treffen an dem du teilnimmst'
  end

  def meeting
    activity.trackable
  end

end
