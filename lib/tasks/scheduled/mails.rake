namespace :scheduled do
  desc 'Send daily summary mail'
  task daily_summary_mail: :environment do
    puts "Rake daily_summary_mail start at #{Time.now}"
    User.find_each do |user|
      Notification::SummaryMail.new(user, :graetzl, :daily).deliver
      Notification::SummaryMail.new(user, :personal, :daily).deliver
    end
  end

  desc 'Send weekly summary mail'
  task weekly_summary_mail: :environment do
    puts "Rake weekly_summary_mail start at #{Time.now}"
    User.find_each do |user|
      Notification::SummaryMail.new(user, :graetzl, :weekly).deliver if Date.today.tuesday?
      Notification::SummaryMail.new(user, :personal, :weekly).deliver if Date.today.saturday?
    end
  end

  task test_daily_summary_mail: :environment do
    user = User.find_by(email: "michael.walchhuetter@gmail.com")
    Notification::SummaryMail.new(user, :graetzl, :daily).deliver
    Notification::SummaryMail.new(user, :personal, :daily).deliver
  end

  task test_weekly_summary_mail: :environment do
    user = User.find_by(email: "michael.walchhuetter@gmail.com")
    Notification::SummaryMail.new(user, :graetzl, :weekly).deliver
    Notification::SummaryMail.new(user, :personal, :weekly).deliver
  end

end
