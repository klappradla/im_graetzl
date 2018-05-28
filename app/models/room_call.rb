class RoomCall < ApplicationRecord
  extend FriendlyId
  friendly_id :title

  belongs_to :user
  belongs_to :graetzl
  belongs_to :district

  #has_one :group

  has_many :room_call_fields
  accepts_nested_attributes_for :room_call_fields, allow_destroy: true, reject_if: :all_blank
  has_many :room_call_submissions

  has_many :room_call_modules
  has_many :room_modules, through: :room_call_modules
  accepts_nested_attributes_for :room_call_modules, allow_destroy: true, reject_if: :all_blank

  has_many :room_call_prices
  accepts_nested_attributes_for :room_call_prices, allow_destroy: true, reject_if: :all_blank

  belongs_to :location, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  attachment :cover_photo, type: :image
  attachment :avatar, type: :image
  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :address, :title, :starts_at, :ends_at, :description, :about_us, :about_partner,
  :cover_photo, :first_name, :last_name, :email, :room_call_fields

  before_create :set_graetzl_and_district

  scope :open_calls, -> { where("starts_at <= current_date AND ends_at >= current_date") }

  def open?
    (starts_at..ends_at).cover?(Date.current)
  end

  private

  def set_graetzl_and_district
    self.graetzl = address.graetzl if address
    self.district = graetzl.district if graetzl
  end

end