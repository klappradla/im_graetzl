class AddOnlineMeetingToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :online_meeting, :boolean, default: false
  end
end
