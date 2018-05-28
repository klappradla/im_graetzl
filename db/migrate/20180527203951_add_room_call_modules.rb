class AddRoomCallModules < ActiveRecord::Migration[5.0]
  def change
    create_table :room_modules do |t|
      t.string :name
      t.string :image_id
      t.string :image_content_type
      t.timestamps
    end

    create_table :room_call_modules do |t|
      t.references :room_call, foreign_key: { on_delete: :cascade }, index: true
      t.references :room_module, foreign_key: { on_delete: :cascade }, index: true
      t.integer :quantity, default: 1
      t.timestamps
    end

    create_table :room_call_prices do |t|
      t.references :room_call, foreign_key: { on_delete: :cascade }, index: true
      t.string :name
      t.text :description
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end
  end
end
