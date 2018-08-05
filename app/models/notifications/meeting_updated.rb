class Notifications::MeetingUpdated < Notification
  TRIGGER_KEY = 'meeting.update'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**3

  def self.receivers(activity)
    activity.trackable.users
  end

  def self.description
    'Änderungen eines Treffens an dem ich teilnehme'
  end

  def custom_mail_vars
    {
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
      meeting_name: activity.trackable.name,
      meeting_url: graetzl_meeting_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS)
    }
  end

  def mail_subject
    'Es gibt Änderungen bei einem Treffen an dem du teilnimmst'
  end
end
