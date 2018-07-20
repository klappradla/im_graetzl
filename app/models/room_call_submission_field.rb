class RoomCallSubmissionField < ApplicationRecord
  belongs_to :room_call_submission
  belongs_to :room_call_field
end
