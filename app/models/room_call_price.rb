class RoomCallPrice < ApplicationRecord
  belongs_to :room_call
  has_many :room_call_price_modules
  has_many :room_modules, through: :room_call_price_modules

  def feature_list
    features.present? ? features.split("\n").select(&:present?) : []
  end
end
