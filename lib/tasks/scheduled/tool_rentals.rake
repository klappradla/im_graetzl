namespace :scheduled do

  desc 'Update Completed Rentals to Return Pending State'
  task update_completed_tool_rentals: :environment do
    ToolRental.approved.where("rent_to < ?", Date.today).find_each do |tool_rental|
      tool_rental.update(rental_status: :return_pending)
      tool_rental.create_activity(:return_pending, owner: tool_rental.user)
      ToolOfferMailer.rental_return_pending(tool_rental).deliver_now
    end
  end

  desc 'Send Reminder for Pending Rentals after 2 days / Expire Rentals when date is over'
  task update_pending_tool_rentals: :environment do

    # Send Reminder for pending Rental Requests
    ToolRental.pending.where(created_at: (Time.now.midnight - 2.days)..Time.now.midnight - 1.day).where("rent_from >= ?", Date.today).find_each do |tool_rental|
      ToolOfferMailer.new_rental_request_reminder(tool_rental).deliver_now
    end

    # Expire Rental Requests where rent_from is in past
    ToolRental.pending.where("rent_from < ?", Date.today).find_each do |tool_rental|
      ToolRentalService.new.expire(tool_rental)
    end

  end

end
