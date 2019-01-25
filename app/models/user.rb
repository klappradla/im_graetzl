class User < ApplicationRecord
  include Trackable
  include User::Notifiable
  extend FriendlyId

  attr_accessor :login # virtual attribute to login with username or email
  friendly_id :username
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  attachment :avatar, type: :image
  attachment :cover_photo, type: :image
  enum role: { admin: 0 }

  belongs_to :graetzl, counter_cache: true
  has_one :curator, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :going_tos, dependent: :destroy
  has_many :meetings, through: :going_tos
  has_many :posts, as: :author, dependent: :destroy, class_name: 'UserPost'
  has_many :comments, dependent: :destroy
  has_many :location_ownerships, dependent: :destroy
  has_many :locations, through: :location_ownerships
  has_many :location_posts, through: :locations, source: :posts
  has_many :room_calls
  has_many :room_offers
  has_many :room_demands

  has_and_belongs_to_many :business_interests
  belongs_to :location_category, optional: true

  has_many :group_join_requests
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :discussions
  has_many :discussion_followings

  has_many :wall_comments, as: :commentable, class_name: Comment, dependent: :destroy
  accepts_nested_attributes_for :address

  validates :graetzl, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :terms_and_conditions, acceptance: true
  validates :website, url: true, allow_blank: true

  validates :location_category, presence: true, on: :create, if: :business?
  validates :business_interests, presence: true, on: :create, if: :business?

  before_validation { self.username.squish! if self.username }

  after_update :update_mailchimp, if: -> { email_changed? || first_name_changed? || last_name_changed? || newsletter_changed? }
  before_destroy :unsubscribe_mailchimp

  scope :business, -> { where(business: true) }

  # overwrite devise authentication method to allow username OR email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions.to_h).
        where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).
        first
    else
      where(conditions.to_h).first
    end
  end

  def self.admin_select_collection
    User.all.pluck(:id, :first_name, :last_name, :username).map do |id, first_name, last_name, username|
      ["#{first_name} #{last_name} (#{username})", id]
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_with_email
    "#{full_name} (#{email})"
  end

  def after_confirmation
    UsersMailer.new.send_welcome_email(self)
    MailchimpSubscribeJob.perform_later(self)
  end

  def primary_location
    self.locations.first
  end

  private

  def update_mailchimp
    MailchimpSubscribeJob.perform_later(self)
  end

  def unsubscribe_mailchimp
    MailchimpUnsubscribeJob.perform_later(self)
  end

end
