class MeetingAdditionalDate < ApplicationRecord
  belongs_to :meeting
  has_many :going_tos
  has_many :users, through: :going_tos

  def display_starts_at_date
    if starts_at_time
      "#{I18n.localize(starts_at_date, format:'%a, %d. %B %Y')}, #{I18n.localize(starts_at_time, format:'%H:%M')} Uhr"
    else
      "#{I18n.localize(starts_at_date, format:'%a, %d. %B %Y')}"
    end
  end

end
