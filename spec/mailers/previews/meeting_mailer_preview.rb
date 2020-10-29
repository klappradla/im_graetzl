class MeetingMailerPreview < ActionMailer::Preview

  def message_to_user
    MeetingMailer.message_to_user(Meeting.first, User.first, User.last, "Hello", "Hello world", "test")
  end

  def missing_meeting_category
    MeetingMailer.missing_meeting_category(Meeting.upcoming.last)
  end

end
