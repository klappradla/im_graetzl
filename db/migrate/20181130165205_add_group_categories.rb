class AddGroupCategories < ActiveRecord::Migration[5.0]
  def change
    rename_table :group_categories, :discussion_categories
    rename_table :group_default_categories, :discussion_default_categories
    rename_column :discussions, :group_category_id, :discussion_category_id

    create_table :group_categories do |t|
      t.string :title
      t.timestamps
    end

    create_join_table :group_categories, :groups do |t|
      t.index :group_id
      t.index :group_category_id
    end
  end
end
