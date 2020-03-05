class GoingToMailer < ApplicationMailer

  def send_invoice(going_to)
    @going_to = going_to
    attachments["#{@going_to.invoice_number}.pdf"] = @going_to.invoice.get.body.read
    headers("X-MC-Tags" => "going-to-invoice")
    mail(to: @going_to.user.email, subject: "Infos zu deinem Ticket")
  end

end
