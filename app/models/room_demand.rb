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

  scope :by_currentness, -> { order(last_activated_at: :desc) }
  scope :reactivated, -> { enabled.where("last_activated_at > created_at").where("created_at < ?", LIFETIME_MONTHS.months.ago) }

  LIFETIME_MONTHS = 6

  validates_presence_of :slogan, :demand_description, :personal_description, :avatar, :first_name, :last_name, :email
  validate :has_one_category_at_least
  validate :has_one_graetzl_at_least # doesn't work for some reason

  before_create :set_last_activated_at
  before_update :create_update_activity?
  after_destroy { MailchimpRoomDeleteJob.perform_later(user) }

  def to_s
    slogan
  end

  def activation_code
    return self.created_at.to_i
  end

  def set_last_activated_at
    self.last_activated_at = Time.now
  end

  def create_update_activity?
    # create update activity if ->
    # enabled & last_activated_at = today
    # and last_activated_at is more then 15 days ago
    # and cerated_at is more then 30 days ago
    if self.enabled? && self.last_activated_at.today? && self.last_activated_at_was <= 30.days.ago && self.created_at <= LIFETIME_MONTHS.months.ago
      self.create_activity(:update, owner: self.user)
    end
  end

  private

  def has_one_category_at_least
    if room_categories.empty?
      errors.add(:room_categories, "braucht mindestens eine Kategorie")
    end
  end

  def has_one_graetzl_at_least
    if graetzl_ids.empty?
      errors.add(:graetzls, "muss ausgewählt werden")
    end
  end
end
