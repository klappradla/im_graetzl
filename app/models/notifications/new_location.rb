class Notifications::NewLocation < Notification
  TRIGGER_KEY = 'location.create'
  BITMASK = 2**5

  def self.receivers(activity)
    User.where(graetzl_id: activity.trackable.graetzl_id)
  end

  def self.description
    'Es gibt eine neue Location in deinem Grätzl'
  end

  def mail_vars
    {
      type: type.demodulize.underscore,
      location_name: activity.trackable.name,
      location_url: graetzl_location_url(activity.trackable.graetzl, activity.trackable, DEFAULT_URL_OPTIONS),
      location_slogan: activity.trackable.slogan,
      location_category: activity.trackable.category.try(:name),
      location_address: printable_address(activity.trackable),
      owner_avatar_url: Notifications::AvatarService.new(activity.trackable).call

    }
  end

  def mail_subject
    'Es gibt eine neue Location in deinem Grätzl'
  end

  private

  def printable_address(location)
    if location.address
      "#{location.address.street_name} #{location.address.street_number}, #{location.address.zip} #{location.address.city}"
    end
  end

end
