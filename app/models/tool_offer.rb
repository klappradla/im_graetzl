class ToolOffer < ApplicationRecord
  include Trackable
  extend FriendlyId

  friendly_id :title

  belongs_to :user
  belongs_to :graetzl
  belongs_to :location, optional: true
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  belongs_to :tool_category, optional: true
  belongs_to :tool_subcategory, class_name: "ToolCategory", optional: true

  has_many :tool_rentals
  has_many :comments, as: :commentable, dependent: :destroy

  enum status: { enabled: 0, disabled: 1, deleted: 2 }

  acts_as_taggable_on :keywords

  attachment :cover_photo, type: :image
  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file, append: true
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  validates_presence_of :title, :description, :address, :tool_category_id, :cover_photo, :price_per_day, :iban

  before_save :set_graetzl

  scope :non_deleted, -> { where.not(status: :deleted) }
  scope :by_currentness, -> { order(created_at: :desc) }

  def self.include_for_box
    includes(:user, :tool_category, :tool_subcategory)
  end

  def to_s
    title
  end

  def daily_price(days)
    if days >= 7
      price_per_day * (100 - weekly_discount.to_i) / 100
    elsif days >= 2
      price_per_day * (100 - two_day_discount.to_i) / 100
    else
      price_per_day
    end
  end

  private

  def set_graetzl
    self.graetzl = address.graetzl if address.present?
  end

end
