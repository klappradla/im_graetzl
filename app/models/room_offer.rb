class RoomOffer < ApplicationRecord
  belongs_to :user
  belongs_to :graetzl
  belongs_to :district
  belongs_to :location, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  has_many :room_offer_categories
  has_many :room_categories, through: :room_offer_categories

  enum offer_type: { one_to_one: 0, hub: 1, coworking_space: 2 }
  acts_as_taggable_on :keywords

  attachment :main_image, type: :image
  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :address
  before_create :set_graetzl_and_district

  def offer_type_text # TODO: write this properly
    offer_type_names = { one_to_one: "One-to-One Raumteiler", hub: "Raumteiler Hub", coworking_space: "Coworking Space"}
    offer_type_names = offer_type_names.stringify_keys
    offer_type_names[self.offer_type]
  end

  private

  def set_graetzl_and_district
    self.graetzl = address.graetzl if address
    self.district = graetzl.district if graetzl
  end
end
