class RoomCallSubmission < ApplicationRecord
  belongs_to :room_call
  belongs_to :user

  has_many :room_call_submission_fields
end
