class AddStatusToJoinRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :group_join_requests, :status, :integer, default: 0
  end
end
