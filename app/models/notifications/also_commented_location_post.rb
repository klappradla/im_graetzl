class Notifications::AlsoCommentedLocationPost < Notification
  TRIGGER_KEY = 'location_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**6

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    'Es gibt neue Antworten auf Inhalte die ich auch kommentiert habe'
  end

  def custom_mail_vars
    {
      #post_title: activity.trackable.title,
      #post_url: graetzl_location_url(activity.trackable.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
      type: 'also_commented',
      headline: 'Neuer Kommentar bei Location-Update:',
      title: activity.trackable.title,
      url: graetzl_location_url(activity.trackable.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
      comment_url: graetzl_location_url(activity.trackable.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
      comment_content: activity.recipient.content.truncate(300, separator: ' '),
      owner_name: activity.owner.username,
      owner_url: user_url(activity.owner, DEFAULT_URL_OPTIONS),
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
    }
  end

  def mail_subject
    "#{activity.owner.username} hat einen Beitrag ebenfalls kommentiert."
  end
end
