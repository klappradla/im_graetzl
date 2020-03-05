class GoingToMailerPreview < ActionMailer::Preview

  def going_to_send_invoice
    GoingToMailer.send_invoice(GoingTo.last)
  end

end
