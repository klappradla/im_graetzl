class Notifications::NewWallComment < Notification
  TRIGGER_KEY = 'user.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**10

  def self.receivers(activity)
    User.where(id: activity.trackable.id)
  end

  def self.condition(activity)
    activity.owner.present? && activity.recipient.present?
  end

  def self.description
    'Jemand hat auf meine Pinnwand geschrieben'
  end

  def custom_mail_vars
    {
      name: 'Neuer Eintrag auf deiner Pinnwand:',
      comment_url: graetzl_user_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS) + "#comment-#{activity.recipient.id}",
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    "#{activity.owner.username} hat auf deine Pinnwand geschrieben."
  end
end
