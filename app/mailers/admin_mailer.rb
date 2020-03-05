class AdminMailer < ApplicationMailer
  default from: 'Info imGrätzl.at <no-reply@imgraetzl.at>'
  default to: 'wir@imgraetzl.at'

  def new_zuckerl(zuckerl)
    @zuckerl = zuckerl
    @location = @zuckerl.location
    mail(subject: "[ImGrätzl] Buchung Grätzlzuckerl von #{@location.name}")
  end

  def new_paid_going_to(going_to)
    @going_to = going_to
    @meeting = @going_to.meeting
    mail(subject: "[ImGrätzl] Ticket-Kauf für #{@meeting.name}")
  end

  def new_payment(amount, email, description, url, message)
    @amount = amount
    @email = email
    @description = description
    @url = url
    @message = message
    if Rails.env.production?
      mail(subject: "Zahlung #{description} von #{email}")
    else
      mail(subject: "[TEST] Zahlung #{description} von #{email}")
    end
  end

end
