class ToolOfferMailer < ApplicationMailer

  def new_rental_request(tool_rental)
    @tool_rental = tool_rental
    mail(to: @tool_rental.tool_offer.user.email, subject: "New Tool Rental request")
  end

  def rental_approved(tool_rental)
    @tool_rental = tool_rental
    mail(to: @tool_rental.user.email, subject: "Your Rental has been approved")
  end

  def rental_rejected(tool_rental)
    @tool_rental = tool_rental
    mail(to: @tool_rental.user.email, subject: "Your Rental has been rejected")
  end

  def rental_canceled(tool_rental)
    @tool_rental = tool_rental
    mail(to: @tool_rental.tool_offer.user.email, subject: "Tool Rental canceled")
  end

end
