class CreateEventCategories < ActiveRecord::Migration[5.2]
  def change

    create_table :event_categories do |t|
      t.string :title
      t.string :css_ico_class
      t.string :main_photo_id
      t.string :main_photo_content_type
      t.integer :position, default: 0
      t.timestamps
    end

    create_join_table :event_categories, :meetings do |t|
      t.index :meeting_id
      t.index :event_category_id
    end

  end
end
