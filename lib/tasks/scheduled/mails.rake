namespace :scheduled do

  desc 'Send messanger notifications'
  task unseen_messages: :environment do
    time_range = 1.day.ago..15.minutes.ago
    UserMessageThread.includes(user_messages: :user, user_message_thread_members: :user).where(last_message_at: time_range).find_each do |thread|
      thread.user_message_thread_members.each do |user_thread|
        unseen_messages = thread.user_messages.select{ |m| m.id > user_thread.last_message_seen_id }
        next if unseen_messages.empty?
        p "#{user_thread.user.email} #{unseen_messages.count} unseen messages."
        MessengerMailer.unseen_messages(user_thread.user, unseen_messages).deliver_now
        user_thread.update(last_message_seen_id: unseen_messages.last.id)
      end
    end
  end

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
