class MeetingMailer < ApplicationMailer

  def message_to_user(meeting, from_user, to_user, subject, message, from_email)
    @meeting, @user, @message = meeting, from_user, message
    @reply_to = from_email.present? ? from_email : from_user.email
    from_email = "no-reply@imgraetzl.at"

    headers(
      "X-MC-Tags" => "meeting-user-mail",
      "X-MC-GoogleAnalytics" => 'staging.imgraetzl.at, www.imgraetzl.at',
      "X-MC-GoogleAnalyticsCampaign" => "meeting-user-mail",
    )
    mail(
      to: to_user.email, from: "#{from_user.full_name} | über imGrätzl.at <#{from_email}>",
      reply_to: @reply_to, subject: subject
    )
  end

end
