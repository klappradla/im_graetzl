class GroupUser < ApplicationRecord
  include Trackable

  belongs_to :group
  belongs_to :user

  enum role: { member: 0, admin: 1 }
end
