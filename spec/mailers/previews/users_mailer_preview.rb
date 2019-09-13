class UsersMailerPreview < ActionMailer::Preview

  def welcome_email
    UsersMailer.welcome_email(User.last)
  end

end
