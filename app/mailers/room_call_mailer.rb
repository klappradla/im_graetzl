class RoomCallMailer < ApplicationMailer

  def notify_submitter(room_call_submission)
    @submission = room_call_submission
    headers("X-MC-Tags" => "room-call-submission")
    mail(to: @submission.user.email, subject: "Danke für deine Teilnahme! Die ersten Infos für dich ...")
  end

  def notify_owner(room_call_submission)
    @submission = room_call_submission
    mail(to: @submission.room_call.user.email, bcc: 'call@imgraetzl.at', subject: "Neue Call Bewerbung.")
  end

end
