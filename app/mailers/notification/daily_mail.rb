class Notification::DailyMail
  include MailUtils

  if Rails.env.staging?
    {
      MANDRILL_TEMPLATE = 'staging-daily-notifications'
    }
  else
    {
      MANDRILL_TEMPLATE = 'daily-notifications'
    }
  end

  BLOCKS = [
    {
      name: 'Neue Location Updates',
      types: [Notifications::NewLocationPost]
    },
    {
      name: 'Neue Treffen',
      types: [Notifications::NewMeeting]
    },
    {
      name: 'Neue Ideen im Grätzl',
      types: [Notifications::NewUserPost, Notifications::NewAdminPost]
    },
    {
      name: 'Neue Räume zum Andocken',
      types: [Notifications::NewRoomOffer]
    },
    {
      name: 'Auf der Suche nach Raum',
      types: [Notifications::NewRoomDemand]
    }
  ]

  def initialize(user)
    @user = user
    @notifications = @user.notifications_of_the_day
  end

  def deliver
    content = generate_content
    if content
      MandrillMailer.deliver(template: MANDRILL_TEMPLATE, message: content)
      @notifications.update_all(sent: true)
    end
  end

  private

  attr_reader :notifications, :user

  def generate_content
    blocks = notification_blocks
    if blocks.present?
      {
        to: [ { email: @user.email } ],
        from_email: FROM_EMAIL,
        from_name: FROM_NAME,
        subject: "Neues aus dem Grätzl #{@user.graetzl.name}",
        global_merge_vars: global_vars,
        merge_vars: [
          rcpt: @user.email,
          vars: [
            { name: 'notification_blocks', content: blocks }
          ]
        ]
      }
    end
  end

  def notification_blocks
    BLOCKS.collect{|b| build_block(b[:name], b[:types])}.compact
  end

  def build_block(name, types)
    notifications = @notifications.where(type: types.map(&:to_s))
    if notifications.present?
      {
        name: name,
        size: notifications.length,
        notifications: notifications.collect{|n| n.mail_vars}
      }
    end
  end

  def global_vars
    [
      { name: 'username', content: @user.username },
      { name: 'edit_user_url', content: edit_user_url(URL_OPTIONS) },
      { name: 'graetzl_name', content: @user.graetzl.name },
      { name: 'graetzl_url', content: graetzl_url(@user.graetzl, URL_OPTIONS) }
    ]
  end
end
