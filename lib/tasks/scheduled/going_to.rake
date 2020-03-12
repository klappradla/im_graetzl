namespace :scheduled do
  desc 'Remind Attendees 1 Day before Meeting Starts'
  task going_to_reminder: :environment do

    puts "--- GoingTo Reminder Mail at: #{Time.now} ---"
    GoingTo.where("going_to_date = ?", Date.tomorrow).find_each do |going_to|
      GoingToMailer.going_to_reminder(going_to).deliver_now
    end

  end
end
