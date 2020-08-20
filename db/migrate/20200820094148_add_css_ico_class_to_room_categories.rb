class AddCssIcoClassToRoomCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :room_categories, :css_ico_class, :string
  end
end
