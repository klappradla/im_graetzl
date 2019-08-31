class ToolCategory < ApplicationRecord
  belongs_to :parent_category, class_name: "ToolCategory"
  has_many :tool_offers

  attachment :main_photo, type: :image

  scope :top, -> { where(parent_category_id: nil) }
  scope :subcategories, -> { where("parent_category_id IS NOT NULL") }

  def to_s
    name
  end

end
