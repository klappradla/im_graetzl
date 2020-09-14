class AddUserIdsToMessageThread < ActiveRecord::Migration[5.2]
  def change
    add_column :user_message_threads, :thread_type, :integer, default: 0
    add_column :user_message_threads, :user_ids, :string
  end
end
