class Notifications::LocationApproved < Notification
  TRIGGER_KEY = 'location.approve'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**11

  def self.receivers(activity)
    activity.trackable.users
  end

  def mail_vars
    {
      location_name: activity.trackable.name,
      location_url: graetzl_location_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS)
    }
  end

  def mail_subject
    'Deine Location wurde freigeschalten'
  end
end
