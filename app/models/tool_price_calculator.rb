class ToolPriceCalculator

  attr_reader :date_from, :date_to

  def initialize(tool_offer, date_from, date_to)
    @tool_offer = tool_offer
    date_from = Date.parse(date_from) if date_from.is_a?(String)
    date_to = Date.parse(date_to) if date_to.is_a?(String)
    @date_from, @date_to = [date_from, date_to].sort
  end

  def days
    (@date_from - @date_to).to_i.abs + 1
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
