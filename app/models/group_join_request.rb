class GroupJoinRequest < ApplicationRecord
  belongs_to :group
  belongs_to :user

  scope :pending, -> { where(rejected: false) }
end
