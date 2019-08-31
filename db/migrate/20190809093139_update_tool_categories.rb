class UpdateToolCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :tool_categories, :main_photo_id, :string
    add_column :tool_categories, :main_photo_content_type, :string
    add_column :tool_categories, :position, :integer, default: 0
  end
end
