class ChangeColumnTypePlatformMeetingJoinRequest < ActiveRecord::Migration[5.2]

  def change
    add_column :platform_meeting_join_requests, :status, :integer, default: 0

    execute "UPDATE platform_meeting_join_requests SET status = CAST(wants_platform_meeting AS INTEGER);"

    remove_column :platform_meeting_join_requests, :wants_platform_meeting
  end

end
