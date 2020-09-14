class RenameThreadUserIds < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_message_threads, :user_ids, :user_key
  end
end
