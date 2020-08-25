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
  has_one :room_rental_price
  accepts_nested_attributes_for :room_rental_price, allow_destroy: true,
    reject_if: proc { |attrs| attrs['price_per_hour'].blank? }

  has_one :room_offer_availability
  accepts_nested_attributes_for :room_offer_availability, reject_if: :all_blank

  has_many :room_rentals
  has_many :room_rental_slots, through: :room_rentals

  has_many :active_room_rentals, -> { where(rental_status: [:pending, :approved]) }, class_name: 'RoomRental'
  has_many :active_rental_slots, through: :active_room_rentals, source: :room_rental_slots

  has_many :room_offer_waiting_users
  has_many :waiting_users, through: :room_offer_waiting_users, source: :user

  has_one :group
  has_many :comments, as: :commentable, dependent: :destroy

  enum offer_type: { offering_room: 0, seeking_roommate: 1 }
  enum status: { enabled: 0, disabled: 1, occupied: 2 }

  acts_as_taggable_on :keywords

  attachment :cover_photo, type: :image
  attachment :avatar, type: :image

  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file, append: true
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :address, :slogan, :room_description, :owner_description, :tenant_description, :cover_photo, :first_name, :last_name, :email
  validate :has_one_category_at_least

  before_save :set_graetzl_and_district
  before_create :set_last_activated_at
  before_update :create_update_activity?
  after_destroy { MailchimpRoomDeleteJob.perform_later(user) }

  scope :by_currentness, -> { order(created_at: :desc) }
  scope :reactivated, -> { enabled.where("last_activated_at > created_at") }
  scope :rentable, -> { joins(:room_rental_price) }

  LIFETIME_MONTHS = 6

  def to_s
    slogan
  end

  def activation_code
    return self.created_at.to_i
  end

  def available_days
    return [] if room_offer_availability.nil?
    (0..6).select{ |d| room_offer_availability.day_enabled?(d) }
  end

  def available_hours(date)
    return [] if room_offer_availability.nil?
    (room_offer_availability.from(date.wday)..room_offer_availability.to(date.wday)).to_a
  end

  def set_last_activated_at
    self.last_activated_at = Time.now
  end

  def create_update_activity?
    # create update activity if last update is at least more then 7 days ago
    if self.enabled? && self.updated_at_was <= 7.days.ago
      self.create_activity(:update, owner: self.user)
    end
  end

  private

  def set_graetzl_and_district
    self.graetzl ||= address.graetzl if address.present?
    self.district ||= graetzl.district if graetzl.present?
  end

  def has_one_category_at_least
    if room_categories.empty?
      errors.add(:room_categories, "braucht mindestens eine Kategorie")
    end
  end
end
