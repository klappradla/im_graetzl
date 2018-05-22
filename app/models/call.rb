class Call < ApplicationRecord
  belongs_to :room_offer
  belongs_to :group

  has_many :call_fields
  has_many :call_submissions

  accepts_nested_attributes_for :call_fields, allow_destroy: true, reject_if: :all_blank
end
