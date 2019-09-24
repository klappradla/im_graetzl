class MessengerMailer < ApplicationMailer

  def unseen_messages(user, messages)
    @user = user
    @messages = messages
    @thread = @messages.first.user_message_thread
    mail(to: user.email, subject: "Du hast neue Nachrichten im Messenger.")
  end

end
