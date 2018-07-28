class Discussion < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :group_category, optional: true
  has_many :discussion_posts

  after_create :set_discussion_last_post

  scope :sticky, -> { where(sticky: true) }
  scope :regular, -> { where(sticky: false) }

  def open?
    !closed?
  end

  def edit_permission?(by_user)
    user == by_user
  end

  def delete_permission?(by_user)
    group.admins.include?(by_user)
  end

  def set_discussion_last_post
    update(last_post_at: created_at)
  end

end
