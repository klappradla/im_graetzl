namespace :scheduled do
  desc 'Remind Attendees 1 Day before Meeting Starts'
  task going_to_reminder: :environment do

    GoingTo.where("going_to_date = ?", Date.tomorrow).find_each do |going_to|
      GoingToMailer.going_to_reminder(going_to).deliver_later
    end

  end
end
