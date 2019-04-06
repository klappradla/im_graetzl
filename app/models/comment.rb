class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file, append: true

  validates :content, presence: true

  before_destroy :destroy_activity_and_notifications, prepend: true

  def edit_permission?(by_user)
    by_user && (by_user.admin? || user_id == by_user.id || commentable == by_user)
  end

  private

  def destroy_activity_and_notifications
    Activity.where(recipient: self).destroy_all
  end
end
