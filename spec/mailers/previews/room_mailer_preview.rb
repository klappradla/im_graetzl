class RoomMailerPreview < ActionMailer::Preview

  def room_offer_published
    RoomMailer.room_offer_published(RoomOffer.last)
  end

  def room_demand_published
    RoomMailer.room_demand_published(RoomDemand.last)
  end

  def waiting_list_updated
    RoomMailer.waiting_list_updated(RoomOffer.last, User.last)
  end

  def room_offer_activate_reminder
    RoomMailer.room_offer_activate_reminder(RoomOffer.last)
  end

  def room_demand_activate_reminder
    RoomMailer.room_demand_activate_reminder(RoomDemand.last)
  end

  # RENTALS

  def new_rental_request
    RoomMailer.new_rental_request(RoomRental.last)
  end

  def new_rental_request_reminder
    RoomMailer.new_rental_request_reminder(RoomRental.last)
  end

  def rental_approved_renter
    RoomMailer.rental_approved_renter(RoomRental.approved.last || RoomRental.last)
  end

  def rental_approved_owner
    RoomMailer.rental_approved_owner(RoomRental.approved.last || RoomRental.last)
  end

  def rental_rejected
    RoomMailer.rental_rejected(RoomRental.rejected.last || RoomRental.last)
  end

  def rental_canceled
    RoomMailer.rental_canceled(RoomRental.canceled.last || RoomRental.last)
  end

end
