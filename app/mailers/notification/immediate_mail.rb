class Notification::ImmediateMail
  include MailUtils

  def initialize(notification)
    @notification = notification
    @user = @notification.user
  end

  def deliver
    MandrillMailer.deliver template: template, message: message
  end

  private

  attr_reader :notification, :user

  def template
    @notification.mail_template
  end

  def message
    {
      to: [ { email: @user.email } ],
      from_email: FROM_EMAIL,
      from_name: FROM_NAME,
      subject: @notification.mail_subject,
      google_analytics_domains: ['staging.imgraetzl.at', 'www.imgraetzl.at'],
      google_analytics_campaign: 'notification-mail',
      global_merge_vars: message_vars,
    }
  end

  def message_vars
    [
      { name: 'username', content: @user.username },
      { name: 'edit_user_url', content: edit_user_url(URL_OPTIONS) },
      { name: 'graetzl_name', content: @user.graetzl.name },
      { name: 'graetzl_url', content: graetzl_url(@user.graetzl, URL_OPTIONS) }
      { name: 'notification', content: @notification.mail_vars }
    ] + @notification.basic_mail_vars
  end
end
