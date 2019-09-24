class MessengerMailer < ApplicationMailer

  def unseen_messages(user, messages)
    @user = user
    @messages = messages
    mail(to: user.email, subject: "You've got new messages")
  end

end
