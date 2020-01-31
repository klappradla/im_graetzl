class AddLastActivatedAtToRoomOfferAndDemand < ActiveRecord::Migration[5.2]
  def change
    add_column :room_offers, :last_activated_at, :date
    add_column :room_demands, :last_activated_at, :date
  end
end
