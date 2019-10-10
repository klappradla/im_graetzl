class ToolOfferMailerPreview < ActionMailer::Preview

  def tool_offer_published
    ToolOfferMailer.tool_offer_published(ToolOffer.last)
  end

  def new_rental_request
    ToolOfferMailer.new_rental_request(ToolRental.last)
  end

  def rental_approved
    ToolOfferMailer.rental_approved(ToolRental.approved.last || ToolRental.last)
  end

  def rental_rejected
    ToolOfferMailer.rental_rejected(ToolRental.rejected.last || ToolRental.last)
  end

  def rental_canceled
    ToolOfferMailer.rental_canceled(ToolRental.canceled.last || ToolRental.last)
  end

  def rental_return_pending
    ToolOfferMailer.rental_return_pending(ToolRental.approved.last || ToolRental.last)
  end

  def return_confirmed_renter
    ToolOfferMailer.return_confirmed_renter(ToolRental.approved.last || ToolRental.last)
  end

  def return_confirmed_owner
    ToolOfferMailer.return_confirmed_owner(ToolRental.approved.last || ToolRental.last)
  end

end
