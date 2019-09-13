class RoomMailer < ApplicationMailer
  default from: 'imGrätzl | Raumteiler <raumteiler@imgraetzl.at>'

  def room_offer_published(room_offer)
    @room_offer = room_offer
    mail(to: @room_offer.user.email, subject: "Dein Raumteiler ist nun online")
  end

  def room_demand_published(room_demand)
    @room_demand = room_demand
    mail(to: @room_demand.user.email, subject: "Dein Raumteiler ist nun online")
  end

  def waiting_list_updated(room_offer, user)
    @room_offer = room_offer
    @user = user
    mail(to: @room_offer.user.email, subject: "Neuer User auf deiner Warteliste")
  end

end
