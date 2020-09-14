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
    mail(to: @room_offer.user.email, subject: "Neuer User auf deiner Raumteiler Warteliste")
  end

  def room_offer_activate_reminder(room_offer)
    @room_offer = room_offer
    headers("X-MC-Tags" => "notification-room-expiring")
    mail(to: @room_offer.user.email, subject: "Dein Raumteiler wurde deaktiviert. Möchtest du diesen reaktivieren?")
  end

  def room_demand_activate_reminder(room_demand)
    @room_demand = room_demand
    headers("X-MC-Tags" => "notification-room-expiring")
    mail(to: @room_demand.user.email, subject: "Dein Raumteiler wurde deaktiviert. Möchtest du diesen reaktivieren?")
  end

  def new_rental_request(room_rental)
    @room_rental = room_rental
    headers("X-MC-Tags" => "room-rental-request")
    mail(to: @room_rental.owner.email, subject: "Neue Raumteiler Buchungsanfrage von #{@room_rental.renter.first_name}")
  end

  def new_rental_request_reminder(room_rental)
    @room_rental = room_rental
    headers("X-MC-Tags" => "room-rental-request-reminder")
    mail(to: @room_rental.owner.email, subject: "Erinnerung: #{@room_rental.renter.first_name} möchte deinen Raum mieten.")
  end

  def rental_approved_renter(room_rental)
    @room_rental = room_rental
    attachments["#{@room_rental.invoice_number}.pdf"] = @room_rental.renter_invoice.get.body.read
    headers("X-MC-Tags" => "room-rental-approved")
    mail(to: @room_rental.renter.email, subject: "#{@room_rental.owner.first_name} hat deine Raumteiler Buchung bestätigt")
  end

  def rental_approved_owner(room_rental)
    @room_rental = room_rental
    attachments["#{@room_rental.invoice_number}_owner.pdf"] = @room_rental.owner_invoice.get.body.read
    attachments["#{@room_rental.invoice_number}_renter.pdf"] = @room_rental.renter_invoice.get.body.read
    headers("X-MC-Tags" => "room-rental-approved")
    mail(to: @room_rental.owner.email, subject: "Bestätigung deiner Raumteiler Vermietung")
  end

  def rental_rejected(room_rental)
    @room_rental = room_rental
    headers("X-MC-Tags" => "room-rental-rejected")
    mail(to: @room_rental.renter.email, subject: "#{@room_rental.owner.first_name} hat deine Raumteiler Buchungsanfrage abgelehnt.")
  end

  def rental_canceled(room_rental)
    @room_rental = room_rental
    headers("X-MC-Tags" => "room-rental-canceled")
    mail(to: @room_rental.owner.email, subject: "#{@room_rental.renter.first_name} hat die Raumteiler Buchungsanfrage zurückgezogen")
  end

end
