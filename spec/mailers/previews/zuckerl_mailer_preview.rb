class ZuckerlMailerPreview < ActionMailer::Preview

  def booking_confirmation
    ZuckerlMailer.booking_confirmation(Zuckerl.last)
  end

  def live_information
    ZuckerlMailer.live_information(Zuckerl.last)
  end

  def invoice
    ZuckerlMailer.invoice(Zuckerl.last)
  end

end
