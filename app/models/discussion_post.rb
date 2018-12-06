class DiscussionPost < ApplicationRecord
  include Trackable

  belongs_to :user
  belongs_to :discussion
  has_one :group, through: :discussion

  has_many :images, as: :imageable, dependent: :destroy
  accepts_attachments_for :images, attachment: :file
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  after_create :set_discussion_last_post

  def edit_permission?(by_user)
    user == by_user
  end

  def delete_permission?(by_user)
    user == by_user || group.admins.include?(by_user)
  end

  private

  def set_discussion_last_post
    discussion.update(last_post_at: created_at)
  end
end
