class GroupCategory < ApplicationRecord
  belongs_to :group
  belongs_to :discussion
end