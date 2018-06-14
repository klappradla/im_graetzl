class RoomCallMailer
  include MailUtils

  def send_submission_email(user, room_call)
    MandrillMailer.deliver(template: 'room-call-submission', message: email_settings(user, room_call))
  end

  private

  def email_settings(user, room_call)
    {
      to: [ { email: user.email } ],
      bcc: [ { email: "call@imgraetzl.at" }],
      global_merge_vars: [
        { name: 'username', content: user.username },
        { name: 'first_name', content: user.first_name },
        { name: 'last_name', content: user.last_name },
        { name: 'room_call_title', content: room_call.title },
        { name: 'room_call_subtitle', content: room_call.subtitle },
        { name: 'room_call_url', content: room_call_url(room_call, URL_OPTIONS) },
        { name: 'room_call_picture_url', content: asset_url(room_call, :cover_photo) }
      ]
    }
  end

  def asset_url(resource, asset_name)
    host = "https://#{Refile.cdn_host || default_host}"
    Refile.attachment_url(resource, asset_name, host: host)
  end

  def default_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end
  
end
