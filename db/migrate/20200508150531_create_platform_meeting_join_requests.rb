class CreatePlatformMeetingJoinRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_meeting_join_requests do |t|
      t.references :meeting, foreign_key: { on_delete: :cascade }, index: true
      t.text :request_message
      t.boolean :wants_platform_meeting, default: false
      t.timestamps
    end
  end
end
