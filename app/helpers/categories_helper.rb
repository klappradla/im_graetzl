module CategoriesHelper
  def location_category_icon(category)
    icon = category.icon || 'icon-location'
    content_tag(:svg, content_tag(:use, nil, { 'xlink:href' => "##{icon}" }), class: icon)
  end
end
