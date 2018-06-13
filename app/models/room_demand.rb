class RoomDemand < ApplicationRecord
  include Trackable
  extend FriendlyId

  friendly_id :slogan

  belongs_to :user
  belongs_to :location, optional: true

  has_many :room_demand_categories
  has_many :room_categories, through: :room_demand_categories

  has_many :room_demand_graetzls
  has_many :graetzls, through: :room_demand_graetzls
  has_many :districts, -> { distinct }, through: :graetzls
  has_many :comments, as: :commentable, dependent: :destroy

  enum demand_type: { seeking_room: 0, seeking_roommate: 1 }
  enum status: { enabled: 0, disabled: 1 }

  acts_as_taggable_on :keywords

  attachment :avatar, type: :image

  scope :by_currentness, -> { order(created_at: :desc) }

  validates_presence_of :slogan, :demand_description, :personal_description, :avatar, :first_name, :last_name, :email
  validate :has_one_category_at_least
  # validate :has_one_graetzl_at_least # doesn't work for some reason

  after_destroy { MailchimpRoomDeleteJob.perform_later(user) }

  private

  def has_one_category_at_least
    if room_categories.empty?
      errors.add(:room_categories, "braucht mindestens eine Kategorie")
    end
  end

  def has_one_graetzl_at_least
    if graetzl_ids.empty?
      errors.add(:graetzls, "braucht mindestens einen Graetzl")
    end
  end
end
