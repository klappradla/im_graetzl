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

end
