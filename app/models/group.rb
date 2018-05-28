class Group < ApplicationRecord
  belongs_to :room_offer, optional: true
  has_many :discussions

  belongs_to :admin, class_name: "User"
  has_many :group_users
  has_many :users, through: :group_users
  has_many :group_join_requests

  def to_s
    name
  end

  def visible_to?(user)
    if private?
      user && users.include?(user)
    else
      true
    end
  end
end
