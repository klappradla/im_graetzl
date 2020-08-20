class AddRoomOfferAvailability < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :billing_address, :text
    create_table :room_offer_availabilities do |t|
      t.references :room_offer, index: true, foreign_key: { on_delete: :cascade }
      (0..6).each do |i|
        t.integer :"day_#{i}_from"
        t.integer :"day_#{i}_to"
      end
      t.timestamps
    end
  end
end
