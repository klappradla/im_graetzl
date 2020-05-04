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

  def mail_subject
    "Neues Gruppentreffen von #{activity.owner.first_name} in der Gruppe #{group.title}"
  end

  def group
    meeting.group
  end

  def meeting
    activity.trackable
  end

end
