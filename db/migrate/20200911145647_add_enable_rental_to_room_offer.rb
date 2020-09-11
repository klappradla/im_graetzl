class AddEnableRentalToRoomOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :room_offers, :rental_enabled, :boolean, default: false
  end
end
