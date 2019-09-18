class UsersMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      from: "Mirjam | imGrätzl.at <mirjam@imgraetzl.at>",
      subject: "Zum Start gibt es gleich ein paar schöne Chancen als Willkommensgeschenk!",
    )
  end

  def location_approved(location, user)
    @location = location
    @user = user
    mail(
      to: @user.email,
      from: "Mirjam | imGrätzl.at <mirjam@imgraetzl.at>",
      subject: "Deine Location wurde freigeschalten",
    )
  end

end
