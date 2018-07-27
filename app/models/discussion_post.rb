class DiscussionPost < ApplicationRecord
  belongs_to :user
  belongs_to :discussion
  has_one :group, through: :discussion

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
