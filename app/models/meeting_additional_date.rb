class MeetingAdditionalDate < ApplicationRecord
  belongs_to :meeting
  has_many :going_tos
  has_many :users, through: :going_tos

  before_destroy :check_for_going_tos, prepend: true

  def display_starts_at_date
    if starts_at_time
      "#{I18n.localize(starts_at_date, format:'%a, %d. %B %Y')}, #{I18n.localize(starts_at_time, format:'%H:%M')} Uhr"
    else
      "#{I18n.localize(starts_at_date, format:'%a, %d. %B %Y')}"
    end
  end

  private

    def check_for_going_tos
      self.going_tos.update_all(
        going_to_date: nil,
        going_to_time: nil
      )
    end

end
