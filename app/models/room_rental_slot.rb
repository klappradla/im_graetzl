class RoomRentalSlot < ApplicationRecord
  include Trackable
  belongs_to :room_rental

  def hours
    hour_to - hour_from
  end

end
