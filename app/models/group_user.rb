class GroupUser < ApplicationRecord
  include Trackable

  belongs_to :group
  belongs_to :user

  enum role: { member: 0, admin: 1 }

  def join_request
    user.group_join_requests.detect{|jr| jr.group_id == group_id}
  end
end
