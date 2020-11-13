class ToolRental < ApplicationRecord
  include Trackable
  belongs_to :user
  belongs_to :tool_offer

  has_one :user_message_thread

  enum rental_status: { incomplete: 0, pending: 1, canceled: 2, rejected: 3, approved: 4, return_pending: 5, return_confirmed: 6, expired: 7 }
  enum payment_status: { payment_pending: 0, payment_success: 1, payment_failed: 2, payment_transfered: 3, payment_canceled: 4 }

  scope :submitted, -> { where.not(rental_status: :incomplete) }

  PAYMENT_METHODS = ['card', 'eps'].freeze

  def self.next_invoice_number
    where("invoice_number IS NOT NULL").count + 1
  end

  def owner
    tool_offer.user
  end

  def renter
    user
  end

  def renter_billing_address
    {
      first_name: renter_name && renter_name.split(' ', 2).first,
      last_name: renter_name && renter_name.split(' ', 2).last,
      company: renter_company,
      street: renter_address,
      zip: renter_zip,
      city: renter_city,
    }
  end

  def days
    (rent_to - rent_from).to_i + 1
  end

  def calculate_price
    self.daily_price = tool_offer.price_per_day
    self.basic_price = (daily_price * days).round(2)
    if days >= 7
      self.discount = (basic_price * tool_offer.weekly_discount.to_i / 100).round(2)
    elsif days >= 2
      self.discount = (basic_price * tool_offer.two_day_discount.to_i / 100).round(2)
    else
      self.discount = 0
    end
    self.service_fee = ((basic_price - discount) * 0.065).round(2)
    self.insurance_fee = ((basic_price - discount) * 0.08).round(2)
    self.tax = (service_fee * 0.20).round(2)
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

  def invoice_ready?
    payment_success? || payment_transfered?
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
