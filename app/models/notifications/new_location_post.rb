class Notifications::NewLocationPost < Notification
  TRIGGER_KEY = 'location_post.create'
  DEFAULT_INTERVAL = :weekly
  BITMASK = 2**1

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Eine Location aus meinem Grätzl hat eine Neuigkeit erstellt'
  end

  def self.notify_owner?
    true
  end

  def custom_mail_vars
    {
      post_title: activity.trackable.title,
      post_content: activity.trackable.content.truncate(255, separator: ' '),
      owner_name: activity.trackable.author.name,
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.trackable.author),
      owner_url: graetzl_location_url(activity.trackable.author.graetzl, activity.trackable.author, DEFAULT_URL_OPTIONS),
      post_url: graetzl_location_url(activity.trackable.graetzl, activity.trackable.author, anchor: ApplicationController.helpers.dom_id(activity.trackable), host: DEFAULT_URL_OPTIONS[:host]),
    }
  end

  def mail_subject
    "Neuer Beitrag im Grätzl #{activity.trackable.graetzl.name}"
  end
end
