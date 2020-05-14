module CategoriesHelper

  def location_category_icon(category)
    icon = category.icon || 'location'
    icon_tag(icon)
  end

  def actual_meeting_category

    # Find actual Meeting Category
    actual_meeting = MeetingCategory.where('starts_at_date <= ?', DateTime.now).where('ends_at_date >= ?', DateTime.now).first

    # Find next Meeting Category, if actual not present
    unless actual_meeting.present?
      actual_meeting = MeetingCategory.where('starts_at_date > ?', DateTime.now).first
    end

    actual_meeting.id if actual_meeting.present?

  end

end
