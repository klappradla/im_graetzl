class ZuckerlMailer < ApplicationMailer

  def booking_confirmation(zuckerl)
    @zuckerl = zuckerl
    @user = @zuckerl.location.boss
    mail(to: @user.email, subject: "Grätzlzuckerl Buchungsbestätigung & Infos zur Zahlung")
  end

  def live_information(zuckerl)
    @zuckerl = zuckerl
    @user = @zuckerl.location.boss
    mail(to: @user.email, subject: "Dein Grätzlzuckerl ist jetzt online")
  end

  def invoice(zuckerl)
    @zuckerl = zuckerl
    @user = @zuckerl.location.boss
    headers("X-MC-Tags" => "zuckerl-paid")
    mail(to: @user.email, bcc_address: 'michael@imgraetzl.at', subject: "Zahlungsbestätigung deines Grätzlzuckerls")
  end

end
