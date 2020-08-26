class RoomRentalSlot < ApplicationRecord
  include Trackable
  belongs_to :room_rental

  def hour_list
    (hour_from...hour_to).to_a
  end

  def hours
    hour_to - hour_from
  end

end
