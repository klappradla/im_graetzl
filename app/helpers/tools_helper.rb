module ToolsHelper

  def tool_insurance_values
    [1000, 2000, 3000, 4000, 5000].map do |value|
      ["Bis zu #{value} €", value]
    end
  end

  def tool_discount_values
    [5, 10, 15, 20, 25, 30, 40, 50].map do |value|
      ["#{value} %", value]
    end
  end

  def user_rating(user)
    user_rating = 4.2
    html = content_tag(:div, class: 'rating') do
      content_tag(:span, '☆', class: 'fill') +
      content_tag(:span, '☆', class: user_rating > 1.5 ? 'fill' : nil) +
      content_tag(:span, '☆', class: user_rating > 2.5 ? 'fill' : nil) +
      content_tag(:span, '☆', class: user_rating > 3.5 ? 'fill' : nil) +
      content_tag(:span, '☆', class: user_rating > 4.5 ? 'fill' : nil)
    end
    html += content_tag(:small, "#{user_rating} von 5", class: 'txt')
    html
  end
end
