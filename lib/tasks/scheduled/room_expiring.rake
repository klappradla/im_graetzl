namespace :scheduled do
  desc 'Reminder for Room expiring'
  task reminder_room_expiring: :environment do

    room_offer_lifetime_months = RoomOffer::LIFETIME_MONTHS

    # Disable expiring Rooms and send reminder mail for activating
    RoomOffer.enabled.where("last_activated_at < ?", room_offer_lifetime_months.months.ago).find_each do |room_offer|
      room_offer.update(status: "disabled")
      RoomMailer.room_offer_activate_reminder(room_offer).deliver_later
    end

    room_demand_lifetime_months = RoomDemand::LIFETIME_MONTHS

    # Disable expiring Rooms and send reminder mail for activating
    RoomDemand.enabled.where("last_activated_at < ?", room_demand_lifetime_months.months.ago).find_each do |room_demand|
      room_demand.update(status: "disabled")
      RoomMailer.room_demand_activate_reminder(room_demand).deliver_later
    end

  end
end
