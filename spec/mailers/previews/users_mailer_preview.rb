class UsersMailerPreview < ActionMailer::Preview

  def welcome_email
    UsersMailer.welcome_email(User.last)
  end

  def location_approved
    UsersMailer.location_approved(Location.last, Location.last.users.last)
  end

end
