class GoingToMailerPreview < ActionMailer::Preview

  def going_to_send_invoice
    GoingToMailer.send_invoice(GoingTo.last)
  end

  def going_to_reminder
    GoingToMailer.going_to_reminder(GoingTo.last)
  end

end
