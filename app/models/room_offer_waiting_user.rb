class RoomOfferWaitingUser < ApplicationRecord
  belongs_to :room_offer
  belongs_to :user

end
