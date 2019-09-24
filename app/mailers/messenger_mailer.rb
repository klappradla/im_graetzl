class MessengerMailer < ApplicationMailer

  def unseen_messages(user, messages)
    @user = user
    @messages = messages
    mail(to: user.email, subject: "Du hast neue Nachrichten im Messenger.")
  end

end
