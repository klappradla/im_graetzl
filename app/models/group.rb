class Group < ApplicationRecord
  belongs_to :room_call, optional: true
  belongs_to :room_offer, optional: true
  has_many :discussions
  has_many :discussion_posts, through: :discussions

  has_many :group_users
  has_many :users, through: :group_users

  has_many :group_join_requests

  def to_s
    title
  end

  def parent
    room_call || room_offer
  end

  def admins
    group_users.select{|gu| gu.admin? }.map(&:user)
  end

  def members
    group_users.select{|gu| gu.member? }.map(&:user)
  end

  def readable_by?(user)
    if private?
      user && users.include?(user)
    else
      true
    end
  end
end
