namespace :scheduled do
  desc 'Send out daily mail notifications'
  task daily_mail: :environment do
    puts "Rake daily_mail start at #{Time.now}"
    User.find_each do |user|
      Notification::DailyMail.new(user).deliver
    end
  end

  task test_daily_summary_mail: :environment do
    puts "Rake daily_mail start at #{Time.now}"
    user = User.find_by(email: "michael.walchhuetter@gmail.com")
    Notification::SummaryMail.new(user, :graetzl, :daily).deliver
    Notification::SummaryMail.new(user, :rooms, :daily).deliver
    Notification::SummaryMail.new(user, :personal, :daily).deliver
  end

  task test_weekly_summary_mail: :environment do
    puts "Rake daily_mail start at #{Time.now}"
    user = User.find_by(email: "michael.walchhuetter@gmail.com")
    Notification::SummaryMail.new(user, :graetzl, :weekly).deliver
    Notification::SummaryMail.new(user, :rooms, :weekly).deliver
    Notification::SummaryMail.new(user, :personal, :weekly).deliver
  end

end
