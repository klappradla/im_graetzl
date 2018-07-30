class DiscussionFollowing < ApplicationRecord
  belongs_to :user
  belongs_to :discussion
end
