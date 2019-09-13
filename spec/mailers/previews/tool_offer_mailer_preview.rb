class ToolOfferMailerPreview < ActionMailer::Preview

  def new_rental_request
    ToolOfferMailer.new_rental_request(ToolRental.last)
  end

  def rental_approved
    ToolOfferMailer.rental_approved(ToolRental.last)
  end

  def rental_rejected
    ToolOfferMailer.rental_rejected(ToolRental.last)
  end

  def rental_canceled
    ToolOfferMailer.rental_canceled(ToolRental.last)
  end

  def rental_return_pending
    ToolOfferMailer.rental_return_pending(ToolRental.last)
  end
end
