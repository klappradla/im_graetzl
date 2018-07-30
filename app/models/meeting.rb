class Meeting < ApplicationRecord
  include Trackable
  extend FriendlyId

  scope :by_currentness, -> {
    active.
    order('CASE WHEN starts_at_date >= current_date THEN 0 WHEN starts_at_date IS NOT NULL THEN 1 ELSE 2 END').
    order('(CASE WHEN starts_at_date >= current_date THEN starts_at_date END) ASC,
            (CASE WHEN starts_at_date < current_date THEN starts_at_date END) DESC')
  }
  scope :upcoming, -> { active.
    where("(starts_at_date > ?) OR (starts_at_date IS NULL)", Date.yesterday).
    order(:starts_at_date) }
  # scopes primarily used for users
  scope :initiated, -> { includes(:going_tos, :graetzl)
                        .where('going_tos.role = ?', GoingTo::roles[:initiator]).references(:going_tos)
                        .order(starts_at_date: :desc) }
  scope :attended, -> { includes(:going_tos, :graetzl)
                        .where('going_tos.role = ?', GoingTo::roles[:attendee]).references(:going_tos)
                        .order(starts_at_date: :desc) }

  friendly_id :name
  attachment :cover_photo, type: :image
  enum state: { active: 0, cancelled: 1 }

  belongs_to :graetzl
  has_many :districts, through: :graetzl
  belongs_to :location, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :going_tos, dependent: :destroy
  accepts_nested_attributes_for :going_tos, allow_destroy: true
  has_many :users, through: :going_tos
  has_many :categorizations, as: :categorizable
  accepts_nested_attributes_for :categorizations, allow_destroy: true
  has_many :categories, through: :categorizations
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :group, optional: true

  validates :name, presence: true
  validates :graetzl, presence: true
  validate :starts_at_date_cannot_be_in_the_past, on: :create

  after_create :update_location_activity

  def self.visible_to_all
    where(group_id: nil)
  end

  def self.visible_to(user)
    if user && user.group_ids.present?
      where(group_id: nil).or(where(group_id: user.group_ids))
    else
      where(group_id: nil)
    end
  end

  def self.include_for_box
    includes(:graetzl, :going_tos, :users, location: :users)
  end

  def initiator
    going_tos.find{ |gt| gt.initiator? }.try(:user)
  end

  def responsible_user_or_location
    initiator_user = initiator
    if location && location.users.include?(initiator_user)
      location
    else
      initiator_user
    end
  end

  def display_address
    address || location.try(:address)
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

  def public?
    group_id.nil?
  end

  private

  def starts_at_date_cannot_be_in_the_past
    if starts_at_date && starts_at_date < Date.today
      errors.add(:starts_at, 'kann nicht in der Vergangenheit liegen')
    end
  end

  def update_location_activity
    location.update(last_activity_at: created_at) if location
  end
end
