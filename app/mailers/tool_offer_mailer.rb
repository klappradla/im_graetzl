class ToolOfferMailer < ApplicationMailer

  def new_rental_request(tool_rental)
    @tool_rental = tool_rental
    @tool_offer = tool_rental.tool_offer
    @calculator = ToolPriceCalculator.new(@tool_offer, @tool_rental.rent_from, @tool_rental.rent_to)
    headers("X-MC-Tags" => "tool-rental-request")
    mail(to: @tool_rental.tool_offer.user.email, subject: "Neue Toolteiler Anfrage")
  end

  def rental_approved(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-approved")
    mail(to: @tool_rental.user.email, subject: "Deine Toolteiler Buchung wurde bestätigt")
  end

  def rental_rejected(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-rejected")
    mail(to: @tool_rental.user.email, subject: "Deine Toolteiler Anfrage wurde leider abgelehnt.")
  end

  def rental_canceled(tool_rental)
    @tool_rental = tool_rental
    headers("X-MC-Tags" => "tool-rental-canceled")
    mail(to: @tool_rental.tool_offer.user.email, subject: "#{@tool_rental.user.first_name} hat die Toolteiler Anfrage zurückgezogen")
  end

end
