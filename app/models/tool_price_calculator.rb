class ToolPriceCalculator

  attr_reader :rent_from, :rent_to, :tool_offer

  def initialize(tool_offer, rent_from, rent_to)
    @tool_offer = tool_offer
    rent_from = Date.parse(rent_from) if rent_from.is_a?(String)
    rent_to = Date.parse(rent_to) if rent_to.is_a?(String)
    @rent_from, @rent_to = [rent_from, rent_to].sort
  end

  def days
    (@rent_from - @rent_to).to_i.abs + 1
  end

  def daily_price
    @tool_offer.price_per_day
  end

  def basic_price
    (daily_price * days).round(2)
  end

  def discount
    if days >= 7
      (basic_price * @tool_offer.weekly_discount.to_i / 100).round(2)
    elsif days >= 2
      (basic_price * @tool_offer.two_day_discount.to_i / 100).round(2)
    else
      0
    end
  end

  def total_fee
    service_fee + insurance_fee
  end

  def service_fee
    ((basic_price - discount) * 0.12).round(2)
  end

  def insurance_fee
    ((basic_price - discount) * 0.08).round(2)
  end

  def total
    basic_price - discount + total_fee
  end
end
