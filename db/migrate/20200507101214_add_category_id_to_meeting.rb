class AddCategoryIdToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :meeting_category_id, :integer
    add_index :meetings, :meeting_category_id
    add_foreign_key :meetings, :meeting_categories, on_delete: :nullify
  end
end
