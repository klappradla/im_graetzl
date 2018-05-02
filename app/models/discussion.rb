class Discussion < ApplicationRecord
  belongs_to :group  
  has_many :discussion_posts
  accepts_nested_attributes_for :discussion_posts
end
