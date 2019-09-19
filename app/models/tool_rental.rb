class ToolRental < ApplicationRecord
  belongs_to :user
  belongs_to :tool_offer

  has_one :user_message_thread

  enum rental_status: { pending: 0, canceled: 1, rejected: 2, approved: 3, return_pending: 4, return_confirmed: 5 }
  enum payment_status: { payment_pending: 0, payment_success: 1, payment_failed: 2, payment_transfered: 3 }

  PAYMENT_METHODS = ['card', 'klarna', 'eps'].freeze

  def self.next_invoice_number
    ToolRental.where("invoice_number IS NOT NULL").count + 1
  end

  def owner
    tool_offer.user
  end

  def renter
    user
  end

  def days
    (rent_to - rent_from).to_i + 1
  end

  def total_price
    basic_price - discount + total_fee
  end

  def total_fee
    service_fee + tax + insurance_fee
  end

  def owner_payout_amount
    basic_price - discount - service_fee - tax
  end

  def owner_invoice
    bucket = Aws::S3::Resource.new.bucket('invoices.imgraetzl.at')
    bucket.object("#{Rails.env}/tool_rentals/#{id}-owner.pdf")
  end

  def renter_invoice
    bucket = Aws::S3::Resource.new.bucket('invoices.imgraetzl.at')
    bucket.object("#{Rails.env}/tool_rentals/#{id}-renter.pdf")
  end

end
