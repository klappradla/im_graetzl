class Group < ApplicationRecord
  belongs_to :admin
  belongs_to :room_offer, optional: true
  has_many :discussions
  has_many :users, through: :group_users

  def to_s
    name
  end

end
