class Post < ApplicationRecord
  include Trackable
  extend FriendlyId

  friendly_id :title

  belongs_to :author, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file, append: true
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :author, presence: true

  def edit_permission?(user)
    user && user.admin?
  end

end
