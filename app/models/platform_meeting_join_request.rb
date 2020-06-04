class PlatformMeetingJoinRequest < ApplicationRecord
  belongs_to :meeting

  enum status: { no: 0, pending: 1, approved: 2, processing: 3, declined: 4 }

end
