class Discussion < ApplicationRecord
  include Trackable

  belongs_to :group
  belongs_to :user
  belongs_to :discussion_category, optional: true

  has_many :discussion_posts, dependent: :destroy
  has_many :discussion_followings
  has_many :following_users, through: :discussion_followings, source: :user

  has_one :first_post, -> { where(initial_post: true) }, class_name: "DiscussionPost"

  after_create :set_discussion_last_post

  scope :sticky, -> { where(sticky: true) }
  scope :regular, -> { where(sticky: false) }

  def open?
    !closed?
  end

  def edit_permission?(by_user)
    by_user && user_id == by_user.id
  end

  def delete_permission?(by_user)
    group.admins.include?(by_user)
  end

  def followed_by?(by_user)
    discussion_followings.where(user: by_user).exists?
  end

  private

  def set_discussion_last_post
    update(last_post_at: created_at)
  end

end
