class RoomOfferPrice < ApplicationRecord
  belongs_to :room_offer

  validates_presence_of :name, :amount
end
