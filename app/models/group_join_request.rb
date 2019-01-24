class GroupJoinRequest < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  def has_content?
    join_answers.present? || request_message?
  end

end
