class AddPlatformMeetingToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :platform_meeting, :boolean, default: false
  end
end
