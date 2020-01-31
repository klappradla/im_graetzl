class RoomMailer < ApplicationMailer
  default from: 'imGrätzl | Raumteiler <raumteiler@imgraetzl.at>'

  def room_offer_published(room_offer)
    @room_offer = room_offer
    headers("X-MC-Tags" => "notification-room-online")
    mail(to: @room_offer.user.email, subject: "Dein Raumteiler ist nun online")
  end

  def room_demand_published(room_demand)
    @room_demand = room_demand
    headers("X-MC-Tags" => "notification-room-online")
    mail(to: @room_demand.user.email, subject: "Dein Raumteiler ist nun online")
  end

  def waiting_list_updated(room_offer, user)
    @room_offer = room_offer
    @user = user
    headers("X-MC-Tags" => "notification-room-waitinglist")
    mail(to: @room_offer.user.email, subject: "Neuer User auf deiner Warteliste")
  end

  def room_offer_activate_reminder(room_offer)
    @room_offer = room_offer
    headers("X-MC-Tags" => "notification-room-expiring")
    mail(to: @room_offer.user.email, subject: "Dein Raumteiler ist abgelaufen. Möchtest du diesen reaktivieren?")
  end

  def room_demand_activate_reminder(room_demand)
    @room_demand = room_demand
    headers("X-MC-Tags" => "notification-room-expiring")
    mail(to: @room_demand.user.email, subject: "Dein Raumteiler ist abgelaufen. Möchtest du diesen reaktivieren?")
  end

end
