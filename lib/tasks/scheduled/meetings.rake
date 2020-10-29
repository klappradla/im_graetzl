namespace :scheduled do
  desc 'Set new startDate if in past and additional future Date exists'
  task update_meeting_date: :environment do

    # Delete all PAST Additonal Dates
    MeetingAdditionalDate.where('starts_at_date < ?', Date.today).each do |model|
      model.destroy
    end

    # Find all Meetings where Start Date = Yesterday
    # Look if they have Additonal Dates in Future
    # Set new startDate for Meeting
    # Delete next Additonal Date
    # Update Activity if previous Activity of this Meeting is more then 1 Week ago
    Meeting.where("starts_at_date = ?", Date.yesterday).find_each do |meeting|
      if meeting.meeting_additional_dates.present?
        next_meeting = meeting.meeting_additional_dates.sort_by(&:starts_at_date).first
        meeting.update(starts_at_date: next_meeting.starts_at_date)
        next_meeting.destroy
        Rails.logger.info("[Meeting] Meeting (#{meeting.id}) updated next meeting date: #{next_meeting.starts_at_date}")

        # Update Activity for this Meeting if last Activity is greather then 1 week ago
        if meeting.activities.where(key: 'meeting.create').present? && meeting.activities.where(key: 'meeting.create').last.created_at < 1.weeks.ago
          meeting.activities.where(key: 'meeting.create').destroy_all
          meeting.create_activity :create, owner: meeting.user, cross_platform: meeting.online_meeting?
        end

      end
    end

  end

  desc 'Send Info Mail to Upcoming Meetings without Category'
  task info_mail_missing_meeting_category: :environment do
    user_id = nil
    Meeting.upcoming.includes(:event_categories).where(event_categories: {id: nil}).find_each do |meeting|
      next if user_id == meeting.user.id
      MeetingMailer.missing_meeting_category(meeting).deliver_now
      user_id = meeting.user.id
    end
  end

end
