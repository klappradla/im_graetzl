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
        { name: 'request_message', content: join_request.request_message },
        { name: 'group_name', content: join_request.group.title },
        { name: 'group_url', content: group_url(join_request.group, URL_OPTIONS) },
        { name: 'user_url', content: user_url(join_request.user, URL_OPTIONS) },
        { name: 'user_avatar_url', content: Notifications::ImageService.new.avatar_url(join_request.user) }
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
        { name: 'group_name', content: group.title },
        { name: 'group_url', content: group_url(group, URL_OPTIONS) }
      ]
    })
  end

  def message_to_users(group, users, subject, body, from_email)
    from_email = from_email.present? ? "#{from_email}@imgraetzl.at" : "no-reply@imgraetzl.at"
    MandrillMailer.deliver(template: 'group-user-message', message: {
      to: users.map{ |u| { email: u.email } },
      from_email: from_email,
      subject: subject,
      global_merge_vars: [
        { name: 'email_body', content: body },
        { name: 'group_name', content: group.title },
        { name: 'group_url', content: group_url(group, URL_OPTIONS) }
      ]
    })
  end

  private

  def owner_personal_vars(user)
    {
      rcpt: user.email,
      vars: [{ name: 'owner_first_name', content: user.first_name }]
    }
  end

end
