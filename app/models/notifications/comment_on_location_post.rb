class Notifications::CommentOnLocationPost < Notification
  TRIGGER_KEY = 'location_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    activity.trackable.author.users
  end

  def self.condition(activity)
    activity.trackable.author.present? && activity.trackable.author_type == "Location" && activity.trackable.author.users.exclude?(activity.owner)
  end

  def self.description
    "Meine erstellten Inhalte wurden kommentiert"
  end

  def custom_mail_vars
    {
      post_title: activity.trackable.title,
      post_url: graetzl_location_url(activity.trackable.author.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
      title: activity.trackable.title,
      url: graetzl_location_url(activity.trackable.author.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
      comment_url: graetzl_location_url(activity.trackable.author.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner)
    }
  end

  def mail_subject
    'Neuer Kommentar auf deinen Beitrag'
  end
end
