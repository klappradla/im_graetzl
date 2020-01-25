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
    Meeting.where("starts_at_date = ?", Date.yesterday).find_each do |meeting|
      if meeting.meeting_additional_dates.present?
        next_meeting = meeting.meeting_additional_dates.sort_by(&:starts_at_date).first
        meeting.update(starts_at_date: next_meeting.starts_at_date)
        meeting.create_activity :create, owner: meeting.user
        next_meeting.destroy
      end
    end

  end
end
