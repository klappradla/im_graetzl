class CreateToolteiler < ActiveRecord::Migration[5.2]
  def change
    create_table :tool_categories do |t|
      t.string :name
      t.integer :parent_category_id, foreign_key: { on_table: :tool_categories, on_delete: :nullify }, index: true
      t.timestamps
    end

    create_table :tool_offers do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.string :brand
      t.string :model
      t.string :cover_photo_id
      t.string :cover_photo_content_type
      t.references :tool_category, foreign_key: { on_delete: :nullify }, index: true
      t.integer :tool_subcategory_id, foreign_key: { on_table: :tool_categories, on_delete: :nullify }, index: true
      t.references :user, foreign_key: { on_delete: :cascade }, index: true
      t.references :location, foreign_key: { on_delete: :nullify }, index: true
      t.references :graetzl, foreign_key: { on_delete: :nullify }, index: true
      t.integer :value_up_to
      t.string :serial_number
      t.text :known_defects
      t.decimal :price_per_day, precision: 10, scale: 2
      t.integer :two_day_discount, default: 0
      t.integer :weekly_discount, default: 0
      t.integer :status, default: 0, index: true
      t.string :first_name
      t.string :last_name
      t.string :iban
      t.timestamps
    end

    add_column :users, :iban, :string
  end

end
