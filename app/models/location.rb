class Location < ApplicationRecord
  include Trackable
  extend FriendlyId

  friendly_id :name
  enum state: { pending: 0, approved: 1 }
  enum meeting_permission: { meetable: 0, owner_meetable: 1, non_meetable: 2 }
  attachment :avatar, type: :image
  attachment :cover_photo, type: :image
  acts_as_taggable_on :products

  belongs_to :graetzl
  has_many :districts, through: :graetzl
  has_one :address, as: :addressable, dependent: :destroy
  has_many :posts, as: :author, dependent: :destroy, class_name: 'LocationPost'
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank
  has_one :contact, dependent: :destroy
  accepts_nested_attributes_for :contact
  has_many :location_ownerships, dependent: :destroy
  accepts_nested_attributes_for :location_ownerships, allow_destroy: true
  has_many :users, through: :location_ownerships
  has_many :room_offers
  belongs_to :category
  has_many :meetings
  has_many :upcoming_meetings, -> { upcoming }, class_name: "Meeting"
  has_many :zuckerls, dependent: :destroy
  has_many :live_zuckerls, -> { live }, class_name: "Zuckerl"
  has_one :billing_address, dependent: :destroy
  accepts_nested_attributes_for :billing_address, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :slogan, presence: true
  validates :description, presence: true
  validates :graetzl, presence: true
  validates :category, presence: true


  before_create { |location| location.last_activity_at = Time.current }

  def self.include_for_box
    includes(:graetzl, :posts, :live_zuckerls, :upcoming_meetings, :address, :category)
  end

  def self.meeting_permissions_for_select
    meeting_permissions.map do |t|
      [I18n.t(t[0], scope: [:activerecord, :attributes, :location, :meeting_permissions]), t[0]]
    end
  end

  def approve
    if pending?
      approved!
      create_activity(:create)
      create_activity(:approve)
      MailchimpLocationApprovedJob.perform_later(self)
    end
  end

  def to_s
    name
  end

  def reject
    (pending? && destroy) || nil
  end

  def can_create_meeting?(user)
    meetable? || (owner_meetable? && users.include?(user))
  end

  def boss
    location_ownerships.order(:created_at).first.user
  end

  def editable_by?(user)
    user && user_ids.include?(user.id)
  end

  def build_meeting
    meetings.build(graetzl_id: graetzl_id)
  end
end
