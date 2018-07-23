class ChangeGroupDefaultCategory < ActiveRecord::Migration[5.0]
  def change
    remove_column :group_default_categories, :group_id, foreign_key: true, index: true, on_delete: :cascade
    remove_column :group_default_categories, :group_category_id, foreign_key: true, index: true, on_delete: :cascade
    add_column :group_default_categories, :title, :string
  end
end
