class DiscussionPost < ApplicationRecord
  belongs_to :user
  belongs_to :discussion
  has_one :group, through: :discussion

  def edit_permission?(by_user)
    user == by_user
  end

  def delete_permission?(by_user)
    user == by_user || group.admins.include?(by_user)
  end
end
