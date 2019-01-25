class FixForeignKeys < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :discussion_categories, :groups
    add_foreign_key :discussion_categories, :groups, on_delete: :cascade

    remove_foreign_key :discussion_posts, :users
    add_foreign_key :discussion_posts, :users, on_delete: :nullify

    remove_foreign_key :groups, :room_offers
    add_foreign_key :groups, :room_offers, on_delete: :nullify
  end
end
