class AddRoomOfferWaitingUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :room_offer_waiting_users do |t|
      t.references :room_offer, foreign_key: { on_delete: :cascade }, index: true
      t.references :user, foreign_key: { on_delete: :cascade }, index: true
      t.timestamps
    end
  end
end
