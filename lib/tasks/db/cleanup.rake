namespace :db do
  desc 'Housekeeping for obsolete DB records'
  task cleanup: :environment do
    puts "Rake db:cleanup start at: #{Time.now}"


    puts "Rake db:cleanup delete notifications older than 2 weeks at: #{Time.now}"
    Notification.where('created_at < ?', 2.weeks.ago).destroy_all


    puts "Rake db:cleanup delete activity older than 8 weeks at: #{Time.now}"
    Activity.where('created_at < ?', 8.weeks.ago).destroy_all


    puts "Rake db:cleanup delete activity for disabled content at: #{Time.now}"
    RoomOffer.where(status: 'disabled').find_each do |room_offer|
      room_offer.activities.where(key: ['room_offer.create', 'room_offer.update']).destroy_all
    end
    RoomDemand.where(status: 'disabled').find_each do |room_demand|
      room_demand.activities.where(key: ['room_demand.create', 'room_demand.update']).destroy_all
    end


    puts "Rake db:cleanup delete not paid going_tos from deleted meeting: #{Time.now}"
    GoingTo.where(meeting_id: nil).where.not(role: 2).destroy_all
  end
end
