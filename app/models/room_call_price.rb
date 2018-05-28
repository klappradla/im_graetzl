class RoomCallPrice < ApplicationRecord
  belongs_to :room_call

  acts_as_taggable_on :keywords
end
