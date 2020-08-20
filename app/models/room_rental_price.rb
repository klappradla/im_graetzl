class RoomRentalPrice < ApplicationRecord
  belongs_to :room_offer

  validates_presence_of :price_per_hour

  def daily_price
    8 * price_per_hour * (100 - eight_hour_discount.to_i) / 100
  end

end
