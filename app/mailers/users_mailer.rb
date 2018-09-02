class UsersMailer
  include MailUtils

  def send_welcome_email(user)
    MandrillMailer.deliver(template: 'welcome-new-user', message: email_settings(user))
  end

  private

  def email_settings(user)
    {
      to: [ { email: user.email } ],
      global_merge_vars: [
        { name: 'username', content: user.username },
        { name: 'first_name', content: user.first_name },
        { name: 'last_name', content: user.last_name },
        { name: 'user_type', content: user.business? ? 'business' : 'normal' },
        { name: 'user_origin', content: user.origin },
        { name: 'graetzl_name', content: user.graetzl.name },
        { name: 'graetzl_url', content: graetzl_url(user.graetzl, URL_OPTIONS) }
      ]
    }
  end
end
