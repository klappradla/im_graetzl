module CategoriesHelper
  def location_category_icon(category)
    icon = category.icon || 'location'
    icon_tag(icon)
  end
end
