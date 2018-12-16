class AddForeignKeysToGroupUsers < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :group_users, :users, on_delete: :cascade
    add_foreign_key :group_users, :groups, on_delete: :cascade
  end
end
