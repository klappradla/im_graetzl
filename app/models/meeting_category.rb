class MeetingCategory < ApplicationRecord
  has_many :meetings

  def category_width_date_range_html
    if starts_at_date && ends_at_date
      "#{title}<span class='date'> – #{I18n.localize(starts_at_date, format:'%d. %B')} bis #{I18n.localize(ends_at_date, format:'%d. %B')}</span>"
    else
      title
    end
  end

  def category_width_date_range
    if starts_at_date && ends_at_date
      "#{title} – #{I18n.localize(starts_at_date, format:'%d. %B')} bis #{I18n.localize(ends_at_date, format:'%d. %B')}"
    else
      title
    end
  end

end
