class AddNotifyAtToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :notify_at, :datetime
    add_index :notifications, [:user_id, :notify_at]
  end
end
