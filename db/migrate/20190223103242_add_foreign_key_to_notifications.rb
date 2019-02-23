class AddForeignKeyToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :notifications, :activities, on_delete: :cascade
  end
end
