class CallSubmission < ApplicationRecord
  belongs_to :call
  belongs_to :user

  has_many :call_submission_fields
end
