class ToolRental < ApplicationRecord
  belongs_to :user
  belongs_to :tool_offer

  has_one :user_message_thread

  enum rental_status: { pending: 0, canceled: 1, rejected: 2, approved: 3 }
  enum payment_status: { payment_pending: 0, payment_success: 1, payment_failed: 2, payment_transfered: 3 }

  PAYMENT_METHODS = ['card', 'sofort', 'eps'].freeze

  def days
    (rent_to - rent_from).to_i + 1
  end

  def total_price
    basic_price - discount + service_fee + insurance_fee
  end

end
