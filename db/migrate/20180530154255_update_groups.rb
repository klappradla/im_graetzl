class UpdateGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :room_demands, :status, :integer, default: 0

    remove_column :room_calls, :group_id, :integer
    add_column :groups, :room_call_id, :integer
    add_index :groups, :room_call_id
    add_foreign_key :groups, :room_calls, on_delete: :nullify

    remove_column :groups, :admin_id, :integer
    add_column :group_users, :role, :integer, default: 0

    add_column :discussions, :user_id, :integer
    add_index :discussions, :user_id
    add_foreign_key :discussions, :users, on_delete: :nullify

    add_column :discussions, :last_post_at, :datetime
    add_index :discussions, [:group_id, :sticky, :last_post_at]

    remove_foreign_key :discussion_posts, :discussions
    add_foreign_key :discussion_posts, :discussions, on_delete: :cascade
  end
end
