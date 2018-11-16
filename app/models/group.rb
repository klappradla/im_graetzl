class Group < ApplicationRecord
  belongs_to :room_call, optional: true
  belongs_to :room_offer, optional: true
  has_many :discussions
  has_many :discussion_posts, through: :discussions

  has_many :group_users
  has_many :users, through: :group_users
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank

  has_many :group_join_requests
  has_many :meetings

  has_many :group_categories
  accepts_nested_attributes_for :group_categories, allow_destroy: true, reject_if: :all_blank

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

  def build_meeting
    meetings.build(address: Address.new)
  end

  def readable_by?(user)
    if private?
      user && users.include?(user)
    else
      true
    end
  end

  def room_call_readable_by?(user)
    room_call_id? && admins.include?(user)
  end

  def room_call_submission?(group_user)
    room_call_id? && room_call.room_call_submissions.find_by(user_id: group_user.user.id)
  end

  def room_call_submission_id(group_user)
    room_call.room_call_submissions.includes(:user).find_by(user_id: group_user.user.id)
  end

end
