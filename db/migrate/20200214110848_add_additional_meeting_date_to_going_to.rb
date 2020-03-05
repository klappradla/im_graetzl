class AddAdditionalMeetingDateToGoingTo < ActiveRecord::Migration[5.2]
  def change
    add_reference :going_tos, :meeting_additional_date, index: true
  end
end
