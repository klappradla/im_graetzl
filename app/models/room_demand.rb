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
  has_many :districts, through: :graetzls
  has_many :comments, as: :commentable, dependent: :destroy

  enum demand_type: { seeking_room: 0, seeking_roommate: 1 }
  acts_as_taggable_on :keywords

  attachment :avatar, type: :image

  scope :by_currentness, -> { order(created_at: :desc) }

  validates_presence_of :slogan
end
