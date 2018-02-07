module User::Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, dependent: :destroy
    before_create :set_default_notification_settings
    before_destroy :destroy_activity_and_notifications, prepend: true
  end

  # Website Notifications

  def enable_website_notification(type)
    new_setting = enabled_website_notifications | type::BITMASK
    update_attribute(:enabled_website_notifications, new_setting)
  end

  def enabled_website_notification?(type)
    enabled_website_notifications & type::BITMASK > 0
  end

  def toggle_website_notification(type)
    new_setting = enabled_website_notifications ^ type::BITMASK
    update_attribute(:enabled_website_notifications, new_setting)
  end

  def website_notifications
    notifications.includes(activity: [:owner, :trackable]).
                  where(["bitmask & ? > 0", enabled_website_notifications]).
                  where(display_on_website: true)
  end

  def new_website_notifications_count
    website_notifications.where(seen: false).count
  end

  # Mail Notifications

  def mail_notifications(interval)
    notifications.where(["bitmask & ? > 0", send("#{interval}_mail_notifications".to_sym)])
  end

  def enabled_mail_notification?(type, interval)
    send("#{interval}_mail_notifications".to_sym) & type::BITMASK > 0
  end

  def enable_mail_notification(type, interval)
    [ :immediate, :daily, :weekly ].each do |i|
      disable_mail_notification(type, i)
    end

    new_setting = send("#{interval}_mail_notifications".to_sym) | type::BITMASK
    update_attribute("#{interval}_mail_notifications".to_sym, new_setting)
  end

  def disable_mail_notification(type, interval)
    mask = "11111111111111".to_i(2) ^ type::BITMASK
    new_setting = send("#{interval}_mail_notifications".to_sym) & mask
    update_attribute("#{interval}_mail_notifications".to_sym, new_setting)
  end

  def notifications_of_the_day
    notifications.where(["bitmask & ? > 0", daily_mail_notifications]).
      where("created_at >= NOW() - interval '2 days' AND created_at <= NOW() - interval '5 minutes'").
      where(sent: false)
  end

  private

  def set_default_notification_settings
    self.daily_mail_notifications = [
      Notifications::NewMeeting,
      Notifications::NewLocationPost,
      Notifications::NewLocation,
      Notifications::NewUserPost,
      Notifications::NewRoomOffer,
      Notifications::NewRoomDemand,
    ].sum{|n| n::BITMASK }

    self.immediate_mail_notifications = [
      Notifications::MeetingUpdated,
      Notifications::CommentInMeeting,
      Notifications::AlsoCommentedMeeting,
      Notifications::MeetingCancelled,
      Notifications::AttendeeInUsersMeeting,
      Notifications::NewWallComment,
      Notifications::LocationApproved,
    ].sum{|n| n::BITMASK }

    self.enabled_website_notifications = immediate_mail_notifications
  end

  def destroy_activity_and_notifications
    activity = Activity.where(owner: self)
    notifications = Notification.where(activity: activity)
    notifications.destroy_all
    activity.destroy_all
  end
end
