class RoomRental < ApplicationRecord
  include Trackable
  belongs_to :user
  belongs_to :room_offer

  has_one :user_message_thread

  PAYMENT_METHODS = ['card'].freeze


end
