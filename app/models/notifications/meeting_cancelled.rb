class Notifications::MeetingCancelled < Notification
  TRIGGER_KEY = 'meeting.cancel'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**8

  def self.receivers(activity)
    activity.trackable.users
  end

  def self.description
    'Absage eines Treffens an dem ich teilnehme'
  end

  def mail_subject
    'Absage eines Treffens an dem du teilnimmst'
  end

  def meeting
    activity.trackable
  end
end
