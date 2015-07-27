class Location < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name
  attachment :avatar, type: :image
  attachment :cover_photo, type: :image

  # states
  include AASM
  enum state: { requested: 0, basic: 1, pending: 2, managed: 3 }
  aasm column: :state do
    state :basic, initial: true
    state :requested
    state :pending
    state :managed

    event :request do
      transitions from: :basic, to: :requested
    end

    event :adopt do
      transitions from: :basic, to: :pending
    end

    event :approve do
      transitions from: :pending, to: :managed, after: :update_ownerships
      transitions from: :requested, to: :managed, after: :update_ownerships
    end
  end

  # associations
  belongs_to :graetzl
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  has_one :contact, dependent: :destroy
  accepts_nested_attributes_for :contact
  has_many :location_ownerships, dependent: :destroy
  has_many :users, through: :location_ownerships

  # validations
  validates :name, presence: true

  # instance methods
  def request_ownership(user)
    if user.business? && (pending? || managed?)
      location_ownerships.create(user: user, state: LocationOwnership.states[:requested])
    end
  end

  private

    def update_ownerships
      location_ownerships.pending.each do |ownership|
        ownership.approve!
      end
    end
end
