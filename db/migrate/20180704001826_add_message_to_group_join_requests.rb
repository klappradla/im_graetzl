class AddMessageToGroupJoinRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :group_join_requests, :request_message, :text
    add_column :group_join_requests, :response_message, :text
  end
end
