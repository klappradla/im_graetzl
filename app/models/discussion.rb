class Discussion < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :group_category, optional: true
  has_many :discussion_posts

  scope :sticky, -> { where(sticky: true) }
  scope :regular, -> { where(sticky: false) }

  def open?
    !closed?
  end

  def delete_permission?(by_user)
    group.admins.include?(by_user)
  end

end
