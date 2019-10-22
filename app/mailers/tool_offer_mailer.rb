class ToolOfferMailer < ApplicationMailer

  def tool_offer_published(tool_offer)
    @tool_offer = tool_offer
    headers("X-MC-Tags" => "notification-tool-online")
    mail(to: @tool_offer.user.email, subject: "Dein Toolteiler ist nun online")
  end

  def new_rental_request(tool_rental)
    @tool_rental = tool_rental
    @tool_offer = tool_rental.tool_offer
    headers("X-MC-Tags" => "tool-rental-request")
    mail(to: @tool_rental.owner.email, subject: "Neue Toolteiler Anfrage")
  end

  def rental_approved(tool_rental)
    @tool_rental = tool_rental
    attachments["#{@tool_rental.invoice_number}"] = @tool_rental.renter_invoice.get.body.read
    headers("X-MC-Tags" => "tool-rental-approved")
    mail(to: @tool_rental.renter.email, subject: "Deine Toolteiler Buchung wurde bestätigt")
  end

  def rental_rejected(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-rejected")
    mail(to: @tool_rental.renter.email, subject: "Deine Toolteiler Anfrage wurde leider abgelehnt.")
  end

  def rental_canceled(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-canceled")
    mail(to: @tool_rental.owner.email, subject: "#{@tool_rental.renter.first_name} hat die Toolteiler Anfrage zurückgezogen")
  end

  def rental_return_pending(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-return-pending")
    mail(to: @tool_rental.owner.email, subject: "Bitte bestätige die Rückgabe deines Toolteilers.")
  end

  def return_confirmed_renter(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-return-confirmed-renter")
    mail(to: @tool_rental.renter.email, subject: "#{@tool_rental.owner.first_name} hat die Rückgabe bestätigt. Bewerte nun den Verleihvorgang.")
  end

  def return_confirmed_owner(tool_rental)
    @tool_rental = tool_rental
    attachments["#{@tool_rental.invoice_number}_gutschrift"] = @tool_rental.owner_invoice.get.body.read
    headers("X-MC-Tags" => "tool-rental-return-confirmed-owner")
    mail(to: @tool_rental.owner.email, subject: "Du hast die Rückgabe bestätigt. Deine Gutschrift.")
  end
end
