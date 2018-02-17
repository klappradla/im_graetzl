namespace :db do
  desc 'Housekeeping for obsolete DB records'
  task cleanup: :environment do
    puts "Rake db:cleanup start at: #{Time.now}"
    puts "Rake db:cleanup delete notifications older than 2 weeks at: #{Time.now}"
    Notification.where('created_at < ?', 2.weeks.ago).destroy_all
    puts "Rake db:cleanup delete activity older than 8 weeks at: #{Time.now}"
    Activity.where('created_at < ?', 8.weeks.ago).destroy_all
  end
end
