class GroupDefaultCategory < ApplicationRecord

  def self.all_categories
    pluck(:title).map(&:downcase)
  end
end
