class GroupMailer
  include MailUtils

  def new_join_request(join_request)
    group_admins = join_request.group.admins

    MandrillMailer.deliver(template: 'group-join-request-new', message: {
      to: group_admins.map{ |u| { email: u.email } },
      global_merge_vars: [
        { name: 'username', content: join_request.user.username },
        { name: 'first_name', content: join_request.user.first_name },
        { name: 'last_name', content: join_request.user.last_name },
        { name: 'e_mail', content: join_request.user.email },
        { name: 'user_type', content: join_request.user.business? ? 'business' : 'normal' },
        { name: 'request_message', content: join_request.request_message },
        { name: 'group_name', content: join_request.group.title },
        { name: 'group_url', content: group_url(join_request.group, URL_OPTIONS) },
      ],
      merge_vars: group_admins.map { |user| owner_personal_vars(user) }
    })
  end

  def join_request_accepted(group, user)
    MandrillMailer.deliver(template: 'group-join-request-accepted', message: {
      to: [ { email: user.email } ],
      global_merge_vars: [
        { name: 'username', content: user.username },
        { name: 'first_name', content: user.first_name },
        { name: 'last_name', content: user.last_name },
        { name: 'user_type', content: user.business? ? 'business' : 'normal' },
        { name: 'group_name', content: group.title },
        { name: 'group_url', content: group_url(group, URL_OPTIONS) },
      ]
    })
  end

  private

  def asset_url(resource, asset_name)
    host = "https://#{Refile.cdn_host || default_host}"
    Refile.attachment_url(resource, asset_name, host: host)
  end

  def default_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def owner_personal_vars(user)
    {
      rcpt: user.email,
      vars: [{ name: 'owner_first_name', content: user.first_name }]
    }
  end

end
