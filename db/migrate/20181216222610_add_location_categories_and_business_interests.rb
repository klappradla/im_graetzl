class AddLocationCategoriesAndBusinessInterests < ActiveRecord::Migration[5.0]
  def change
    rename_table :categories, :location_categories
    rename_column :locations, :category_id, :location_category_id
    drop_table :categorizations

    add_column :users, :location_category_id, :integer
    add_foreign_key :users, :location_categories, { on_delete: :nullify }
    add_index :users, :location_category_id

    add_column :users, :business, :boolean, default: false
    
    create_table :business_interests do |t|
      t.string :title
      t.timestamps
    end

    create_join_table :business_interests, :users do |t|
      t.references :business_interest, index: true, foreign_key: { on_delete: :cascade }
      t.references :user, index: true, foreign_key: { on_delete: :cascade }
    end
  end
end
