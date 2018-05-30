class UpdateRoomModules < ActiveRecord::Migration[5.0]
  def change
    remove_column :room_modules, :image_id, :string
    remove_column :room_modules, :image_content_type, :string
    add_column :room_modules, :icon, :string
    add_column :room_call_modules, :description, :text
    add_column :room_call_prices, :features, :text

    create_table :room_call_price_modules do |t|
      t.references :room_call_price, foreign_key: { on_delete: :cascade }, index: true
      t.references :room_module, foreign_key: { on_delete: :cascade }, index: true
    end
  end
end
