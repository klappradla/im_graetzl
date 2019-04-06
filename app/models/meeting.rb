class Meeting < ApplicationRecord
  include Trackable
  extend FriendlyId
  friendly_id :name

  belongs_to :graetzl
  has_many :districts, through: :graetzl

  belongs_to :location, optional: true
  belongs_to :user, optional: true
  belongs_to :group, optional: true

  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address

  has_many :going_tos, dependent: :destroy
  accepts_nested_attributes_for :going_tos, allow_destroy: true
  has_many :users, through: :going_tos

  has_many :comments, as: :commentable, dependent: :destroy

  attachment :cover_photo, type: :image
  enum state: { active: 0, cancelled: 1 }

  scope :by_currentness, -> {
    active.
    order(Arel.sql('CASE WHEN starts_at_date >= current_date THEN 0 WHEN starts_at_date IS NOT NULL THEN 1 ELSE 2 END')).
    order(Arel.sql('(CASE WHEN starts_at_date >= current_date THEN starts_at_date END) ASC, (CASE WHEN starts_at_date < current_date THEN starts_at_date END) DESC'))
  }

  scope :upcoming, -> { active.
    where("starts_at_date > ?", Date.yesterday).
    order(:starts_at_date) }

  validates :name, presence: true
  validates :description, presence: true
  validates :starts_at_date, presence: true
  validates :graetzl, presence: true
  validate :starts_at_date_cannot_be_in_the_past, on: :create

  before_create :set_privacy
  after_create :update_location_activity

  def self.visible_to_all
    where(private: false)
  end

  def self.visible_to(user)
    if user && user.group_ids.present?
      where(private: false).or(where(group_id: user.group_ids))
    else
      where(private: false)
    end
  end

  def self.include_for_box
    includes(:going_tos, :user, location: :users)
  end

  def public?
    !private?
  end

  def display_address
    address || location.try(:address)
  end

  def attending?(user)
    user && going_tos.any?{|gt| gt.user_id == user.id}
  end

  def approve_for_api
    if !approved_for_api?
      update approved_for_api: true
      create_activity(:approve_for_api)
    end
  end

  def disapprove_for_api
    if approved_for_api?
      update approved_for_api: false
      create_activity(:disapprove_for_api)
    end
  end

  private

  def starts_at_date_cannot_be_in_the_past
    if starts_at_date && starts_at_date < Date.today
      errors.add(:starts_at, 'kann nicht in der Vergangenheit liegen')
    end
  end

  def set_privacy
    self.private = true if group && group.private?
  end

  def update_location_activity
    location.update(last_activity_at: created_at) if location
  end
end
