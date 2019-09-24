class MessengerMailerPreview < ActionMailer::Preview

  def unseen_messages
    MessengerMailer.unseen_messages(User.first, UserMessage.last(10))
  end

end
