class ToolPriceCalculator

  def initialize(tool_offer, days)
    @tool_offer = tool_offer
    @days = days
  end

  def days
    @days
  end

  def daily_price
    @tool_offer.price_per_day
  end

  def basic_price
    (daily_price * days).round(2)
  end

  def discount
    if days >= 7
      (basic_price * @tool_offer.weekly_discount / 100).round(2)
    elsif days >= 2
      (basic_price * @tool_offer.two_day_discount / 100).round(2)
    else
      0
    end
  end

  def service_fee
    40
  end

  def total
    (basic_price - discount + service_fee).round(2)
  end
end
