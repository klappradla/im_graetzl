class RoomCallMailer
  include MailUtils

  def send_submission_email(room_call_submission)
    MandrillMailer.deliver(template: 'room-call-submission', message: submitter_settings(room_call_submission))
    MandrillMailer.deliver(template: 'room-call-submission-owner', message: owner_settings(room_call_submission))
  end

  private

  def submitter_settings(submission)
    {
      to: [ { email: submission.user.email } ],
      global_merge_vars: [
        { name: 'username', content: submission.user.username },
        { name: 'first_name', content: submission.user.first_name },
        { name: 'last_name', content: submission.user.last_name },
        { name: 'owner_first_name', content: submission.room_call.user.first_name },
        { name: 'owner_last_name', content: submission.room_call.user.last_name },
        { name: 'owner_email', content: submission.room_call.user.email },
        { name: 'room_call_title', content: submission.room_call.title },
        { name: 'room_call_subtitle', content: submission.room_call.subtitle },
        { name: 'room_call_url', content: room_call_url(submission.room_call, URL_OPTIONS) },
        { name: 'room_call_picture_url', content: asset_url(submission.room_call, :cover_photo) }
      ]
    }
  end

  def owner_settings(submission)
    {
      to: [ { email: submission.room_call.user.email } ],
      bcc: [ { email: "call@imgraetzl.at" }],
      global_merge_vars: [
        { name: 'username', content: submission.user.username },
        { name: 'first_name', content: submission.user.first_name },
        { name: 'last_name', content: submission.user.last_name },
        { name: 'e_mail', content: submission.user.email },
        { name: 'room_call_title', content: submission.room_call.title },
        { name: 'room_call_subtitle', content: submission.room_call.subtitle },
        { name: 'room_call_url', content: room_call_url(submission.room_call, URL_OPTIONS) },
        { name: 'room_call_picture_url', content: asset_url(submission.room_call, :cover_photo) },
        { name: 'room_call_submission', content: submission_content(submission) },
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

  def submission_content(submission)
    submission.room_call_submission_fields.includes(:room_call_field).map do |sf|
      { label: sf.room_call_field.label, content: sf.content }
    end
  end

end
