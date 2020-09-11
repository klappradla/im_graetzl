class AddDailyPriceToToolRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :tool_rentals, :daily_price, :decimal, precision: 10, scale: 2, default: 0
    add_column :tool_rentals, :payment_card_last4, :string
    add_column :room_rentals, :payment_card_last4, :string
  end
end
