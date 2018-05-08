class RoomOffer < ApplicationRecord
  include Trackable
  extend FriendlyId

  friendly_id :slogan

  belongs_to :user
  belongs_to :graetzl
  belongs_to :district
  belongs_to :location, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  has_many :room_offer_categories
  has_many :room_categories, through: :room_offer_categories
  has_many :room_offer_prices
  accepts_nested_attributes_for :room_offer_prices, allow_destroy: true, reject_if: :all_blank

  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  has_one :group
  has_many :comments, as: :commentable, dependent: :destroy

  enum offer_type: { offering_room: 0, seeking_roommate: 1 }
  enum status: { available: 0, occupied: 1, open_call: 2, closed_call: 3}
  acts_as_taggable_on :keywords

  attachment :cover_photo, type: :image
  attachment :avatar, type: :image
  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :address, :slogan, :room_description, :owner_description, :tenant_description, :cover_photo, :first_name, :last_name, :email
  validate :has_one_category_at_least

  before_create :set_graetzl_and_district
  after_destroy { MailchimpRoomDeleteJob.perform_later(user) }

  scope :by_currentness, -> { order(created_at: :desc) }

  def to_s
    slogan
  end

  private

  def set_graetzl_and_district
    self.graetzl = address.graetzl if address
    self.district = graetzl.district if graetzl
  end

  def has_one_category_at_least
    if room_categories.empty?
      errors.add(:room_categories, "braucht mindestens eine Kategorie")
    end
  end
end
