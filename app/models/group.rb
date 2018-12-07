class Group < ApplicationRecord
  include Trackable

  belongs_to :room_call, optional: true
  belongs_to :room_offer, optional: true
  belongs_to :room_demand, optional: true
  belongs_to :location, optional: true

  validates :group_category_ids, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :cover_photo, presence: true
  validates :graetzl_ids, presence: true

  has_many :discussions
  has_many :discussion_posts, through: :discussions

  has_many :group_users
  has_many :users, through: :group_users
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank

  has_many :group_join_requests
  has_many :meetings

  has_many :group_graetzls
  has_many :graetzls, through: :group_graetzls
  has_many :districts, -> { distinct }, through: :graetzls

  has_and_belongs_to_many :group_categories

  has_many :discussion_categories
  accepts_nested_attributes_for :discussion_categories, allow_destroy: true, reject_if: :all_blank

  attachment :cover_photo, type: :image

  scope :by_currentness, -> { order(created_at: :desc) }
  scope :non_private, -> { where(private: false) }
  scope :featured, -> { where(featured: true) }

  def to_s
    title
  end

  def parent
    room_call || room_offer || room_demand || location
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
