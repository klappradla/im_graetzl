namespace :scheduled do

  desc 'Send Reminder for Pending Rentals after 2 days / Expire Rentals when date is over'
  task update_pending_room_rentals: :environment do

    # Send Reminder for pending Rental Requests
    two_days_ago = (2.days.ago.beginning_of_day)..(2.days.ago.end_of_day)
    RoomRental.pending.where(created_at: two_days_ago).includes(:room_rental_slots).find_each do |room_rental|
      if room_rental.rental_start >= Date.today
        RoomMailer.new_rental_request_reminder(room_rental).deliver_now
      end
    end

    # Expire Rental Requests where rent_from is in past
    RoomRental.pending.includes(:room_rental_slots).find_each do |room_rental|
      if room_rental.rental_start < Date.today
        RoomRentalService.new.expire(room_rental)
      end
    end

  end

end
