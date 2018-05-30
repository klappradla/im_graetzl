class RoomModule < ApplicationRecord
  validates_presence_of :icon

  def to_s
    name
  end
end
