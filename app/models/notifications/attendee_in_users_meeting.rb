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

  def custom_mail_vars
    {
      meeting_name: activity.trackable.name,
      meeting_url: graetzl_meeting_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
      cover_photo_url: Notifications::ImageService.new.cover_photo_url(activity.trackable)
    }
  end

  def mail_subject
    "Neuer Teilnehmer an deinem Treffen"
  end

  def meeting_id
    activity.trackable.id
  end

end
