class Notifications::AttendeeInUsersMeeting < Notification
  TRIGGER_KEY = 'meeting.go_to'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**9

  def self.receivers(activity)
    User.where(id: activity.trackable.initiator.id)
  end

  def self.condition(activity)
    activity.trackable.initiator.present? && activity.trackable.initiator.id != activity.owner_id
  end

  def self.description
    'Mein erstelltes Treffen hat einen neuen Teilnehmer'
  end

  def custom_mail_vars
    {
      meeting_name: activity.trackable.name,
      meeting_url: graetzl_meeting_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    "Neuer Teilnehmer an deinem Treffen"
  end
end
