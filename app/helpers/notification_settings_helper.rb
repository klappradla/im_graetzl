module NotificationSettingsHelper
  DAILY_NOTIFICATION_TYPES = [
    Notifications::NewLocationPost,
    Notifications::NewLocation,
    Notifications::NewMeeting,
    Notifications::NewUserPost,
    Notifications::NewRoomOffer,
    Notifications::NewRoomDemand,
  ]

  def notification_settings_mail_options(notification_type)
    if DAILY_NOTIFICATION_TYPES.include? notification_type
      [['off', 'Aus'], ['immediate', 'Sofort'], ['daily', 'Täglich']]
    else
      [['off', 'Aus'], ['immediate', 'Sofort']]
    end
  end
end
