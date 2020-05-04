class Notifications::PaidAttendeeInUsersMeeting < Notification
  TRIGGER_KEY = 'meeting.paid_go_to'
  BITMASK = 0 # System notification

  def self.receivers(activity)
    User.admin
  end

  def self.description
    'Neuer Ticket Verkauf'
  end

  def self.notify_owner?
    true
  end

  def meeting
    activity.trackable
  end

  def meeting_id
    activity.trackable.id
  end
end
