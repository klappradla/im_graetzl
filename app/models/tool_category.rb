class ToolCategory < ApplicationRecord
  belongs_to :parent_category, class_name: "ToolCategory"
  has_many :tool_offers

  def to_s
    name
  end

end
