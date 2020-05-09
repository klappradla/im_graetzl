class PlatformMeetingJoinRequest < ApplicationRecord
  belongs_to :meeting
  scope :wants_platform_meeting, -> { where(wants_platform_meeting: true) }

end
