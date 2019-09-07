class RoomCallMailerPreview < ActionMailer::Preview

  def notify_submitter
    RoomCallMailer.notify_submitter(RoomCallSubmission.last)
  end

  def notify_owner
    RoomCallMailer.notify_owner(RoomCallSubmission.last)
  end

end
