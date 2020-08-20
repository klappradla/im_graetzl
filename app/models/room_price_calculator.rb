class RoomPriceCalculator

  attr_reader :date, :hour_from, :hour_to

  def initialize(room_offer, date, hour_from, hour_to)
    @room_offer = room_offer
    @date = Date.parse(date) if date.is_a?(String)
    @hour_from, @hour_to = [hour_from.to_i, hour_to.to_i].sort
  end

  def hours
    hour_to - hour_from
  end

  def hourly_price
    @room_offer.room_rental_price.price_per_hour
  end

  def basic_price
    (hourly_price * hours).round(2)
  end

  def discount
    if hours >= 8
      (basic_price * @room_offer.room_rental_price.eight_hour_discount.to_i / 100).round(2)
    else
      0
    end
  end

  def tax
    ((basic_price - discount) * 0.20).round(2)
  end

  def total
    basic_price - discount + tax
  end
end
