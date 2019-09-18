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
    read_attribute("#{interval}_mail_notifications") & type::BITMASK > 0
  end

  def enabled_mail_notification(type)
    [:immediate, :daily, :weekly].each do |i|
      return i if enabled_mail_notification?(type, i)
    end
    :off
  end

  def enable_mail_notification(type, interval)
    [:immediate, :daily, :weekly].each do |i|
      if interval == i
        new_setting = read_attribute("#{i}_mail_notifications") | type::BITMASK
      else
        new_setting = read_attribute("#{i}_mail_notifications") & ~type::BITMASK
      end
      write_attribute("#{i}_mail_notifications", new_setting)
    end
    save
  end

  def disable_all_mail_notifications(type)
    [:immediate, :daily, :weekly].each do |i|
      new_setting = read_attribute("#{i}_mail_notifications") & ~type::BITMASK
      write_attribute("#{i}_mail_notifications", new_setting)
    end
    save
  end

  def pending_notifications(period)
    if period == :daily
      notifications.ready_to_be_sent.where(["bitmask & ? > 0", daily_mail_notifications])
    elsif period == :weekly
      notifications.ready_to_be_sent.where(["bitmask & ? > 0", weekly_mail_notifications])
    else
      notification.none
    end
  end
  
  private

  def set_default_notification_settings
    Notification.subclasses.each do |klass|
      case klass::DEFAULT_INTERVAL
      when :weekly
        self.weekly_mail_notifications |= klass::BITMASK
      when :daily
        self.daily_mail_notifications |= klass::BITMASK
      when :immediate
        self.immediate_mail_notifications |= klass::BITMASK
        self.enabled_website_notifications |= klass::BITMASK
      end
    end
  end

  def destroy_activity_and_notifications
    Activity.where(owner: self).destroy_all
  end
end
