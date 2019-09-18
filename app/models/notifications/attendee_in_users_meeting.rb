class Notifications::AttendeeInUsersMeeting < Notification
  TRIGGER_KEY = 'meeting.go_to'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**9

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.condition(activity)
    activity.trackable.user.present? && activity.trackable.user_id != activity.owner_id
  end

  def self.description
    'Mein erstelltes Treffen hat einen neuen Teilnehmer'
  end

  def mail_subject
    "Neuer Teilnehmer an deinem Treffen"
  end

  def meeting
    activity.trackable
  end

  def meeting_id
    activity.trackable.id
  end

end
