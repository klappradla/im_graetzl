namespace :scheduled do
  desc 'Reminder for Room expiring'
  task reminder_room_expiring: :environment do

    room_offer_lifetime_months = RoomOffer::LIFETIME_MONTHS

    # Disable expiring RoomOffers and send reminder mail for activating
    # Only send mail if valid -> status can be updated via link
    # Also deactivate invalids
    RoomOffer.enabled.where("last_activated_at < ?", room_offer_lifetime_months.months.ago).find_each do |room_offer|
      room_offer.update_attribute(:status, "disabled")
      unless room_offer.invalid?
        RoomMailer.room_offer_activate_reminder(room_offer).deliver_later
      end
    end

    room_demand_lifetime_months = RoomDemand::LIFETIME_MONTHS

    # Disable expiring RoomDemands and send reminder mail for activating
    # Only send mail if valid -> status can be updated via link
    # Also deactivate invalids
    RoomDemand.enabled.where("last_activated_at < ?", room_demand_lifetime_months.months.ago).find_each do |room_demand|
      room_demand.update_attribute(:status, "disabled")
      unless room_demand.invalid?
        RoomMailer.room_demand_activate_reminder(room_demand).deliver_later
      end
    end

  end
end
