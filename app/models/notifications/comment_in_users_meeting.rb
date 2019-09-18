class Notifications::CommentInUsersMeeting < Notification
  TRIGGER_KEY = 'meeting.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.condition(activity)
    activity.trackable.user.present? && activity.trackable.user_id != activity.owner_id
  end

  def self.description
    'Meine erstellten Inhalte wurden kommentiert'
  end

  def mail_template
    "commented"
  end

  def mail_subject
    "#{activity.owner.username} hat dein Treffen kommentiert."
  end

  def headline
    'Neuer Kommentar bei deinem Treffen'
  end

  def content_title
    meeting.name
  end

  def content_url_params
    [meeting.graetzl, meeting]
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    [meeting.graetzl, meeting]
  end

  private

  def meeting
    activity.trackable
  end

end
