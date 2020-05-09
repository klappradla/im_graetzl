module CategoriesHelper

  def location_category_icon(category)
    icon = category.icon || 'location'
    icon_tag(icon)
  end

  def actual_meeting_category
    actual_meeting = MeetingCategory.where('starts_at_date <= ?', DateTime.now).where('ends_at_date >= ?', DateTime.now).first
    actual_meeting.id if actual_meeting.present?
  end

end
