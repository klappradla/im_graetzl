class RoomCategory < ApplicationRecord
  has_many :room_offer_categories
  has_many :room_demand_categories

  attachment :main_photo, type: :image

  def to_s
    name
  end
end
