class IndexUsersCreatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :created_at
  end
end
