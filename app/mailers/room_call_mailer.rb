class RoomCallMailer
  include MailUtils

  def send_submission_email(user, room_call)
    MandrillMailer.deliver(template: 'room-call-submission', message: email_settings(user, room_call))
  end

  private

  def email_settings(user, room_call)
    {
      to: [ { email: user.email } ],
      bcc: [ { email: "wir@imgraetzl.at" }],
      global_merge_vars: [
        { name: 'username', content: user.username },
        { name: 'first_name', content: user.first_name },
        { name: 'last_name', content: user.last_name },
        { name: 'user_type', content: user.business? ? 'business' : 'normal' },
        { name: 'room_call_name', content: room_call.title }
      ]
    }
  end
end
