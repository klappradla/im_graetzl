class UpdateDiscussionsCascade < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :discussions, :groups
    add_foreign_key :discussions, :groups, on_delete: :cascade
  end
end
