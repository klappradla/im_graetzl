class Group < ApplicationRecord
  include Trackable

  belongs_to :room_call, optional: true
  belongs_to :room_offer, optional: true
  belongs_to :room_demand, optional: true
  belongs_to :location, optional: true

  validates :title, presence: true
  validates :description, presence: true
  validates :cover_photo, presence: true
  validates :graetzl_ids, presence: true

  has_many :discussions, dependent: :destroy
  has_many :discussion_posts, through: :discussions

  has_many :group_users, -> { includes(:user) }
  has_many :users, through: :group_users
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank

  has_many :group_join_questions
  accepts_nested_attributes_for :group_join_questions, allow_destroy: true, reject_if: :all_blank
  has_many :group_join_requests, -> { includes(:user) }

  has_many :meetings, dependent: :destroy

  has_many :group_graetzls
  has_many :graetzls, through: :group_graetzls
  has_many :districts, -> { distinct }, through: :graetzls

  has_and_belongs_to_many :group_categories

  has_many :discussion_categories
  accepts_nested_attributes_for :discussion_categories, allow_destroy: true, reject_if: :all_blank

  attachment :cover_photo, type: :image

  scope :by_currentness, -> { order(created_at: :desc) }
  scope :non_private, -> { where(private: false) }
  scope :non_hidden, -> { where(hidden: false) }
  scope :featured, -> { where(featured: true) }

  def self.include_for_box
    includes(:group_categories, group_users: :user)
  end

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

  def next_meeting
    meetings.select{|m| m.starts_at_date >= Date.today}.min_by(&:starts_at_date)
  end

  def readable_by?(user)
    if private?
      user && group_users.any?{|gu| gu.user == user}
    else
      true
    end
  end

  def postable_by?(user)
    user && group_users.any?{|gu| gu.user == user}
  end

  def room_call_readable_by?(user)
    room_call_id? && admins.include?(user)
  end

  def user_join_request(group_user)
    group_join_requests.find{|jr| jr.user_id == group_user.user_id }
  end

  def user_room_call_submission(user_id)
    return if !room_call
    room_call.room_call_submissions.find{|jr| jr.user_id == user_id }
  end

end
