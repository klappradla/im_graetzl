class MeetingMailerPreview < ActionMailer::Preview

  def message_to_user
    MeetingMailer.message_to_user(Meeting.first, User.first, User.last, "Hello", "Hello world", "test")
  end

end
