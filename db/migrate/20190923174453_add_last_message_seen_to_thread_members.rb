class AddLastMessageSeenToThreadMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :user_message_thread_members, :last_message_seen_id, :integer, default: 0
  end
end
