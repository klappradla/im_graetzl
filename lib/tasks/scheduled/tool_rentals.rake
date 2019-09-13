namespace :scheduled do
  desc 'Expire old zuckerls, publish new ones'
  task update_completed_tool_rentals: :environment do
    ToolRental.approved.where("rent_to < ?", Date.today).find_each do |tool_rental|
      tool_rental.update(rental_status: :return_pending)
      ToolOfferMailer.rental_return_pending(tool_rental).deliver_now
    end
  end
end
