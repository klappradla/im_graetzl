class AddNotifyUntilToNotifications < ActiveRecord::Migration[5.0]
  def change
    change_column :notifications, :notify_at, :date
    add_column :notifications, :notify_before, :date
  end
end
