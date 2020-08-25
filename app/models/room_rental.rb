class RoomRental < ApplicationRecord
  include Trackable
  belongs_to :user
  belongs_to :room_offer

  has_many :room_rental_slots
  accepts_nested_attributes_for :room_rental_slots, reject_if:
    proc { |attrs| attrs['hour_from'].blank? || attrs['hour_to'].blank? }

  has_one :user_message_thread

  enum rental_status: { incomplete: 0, pending: 1, canceled: 2, rejected: 3, approved: 4 }
  enum payment_status: { payment_pending: 0, payment_success: 1, payment_failed: 2, payment_transfered: 3, payment_canceled: 4 }

  scope :submitted, -> { where.not(rental_status: :incomplete) }

  PAYMENT_METHODS = ['card'].freeze

  def self.next_invoice_number
    where("invoice_number IS NOT NULL").count + 1
  end

  def owner
    room_offer.user
  end

  def renter
    user
  end

  def renter_billing_address
    {
      first_name: renter_name & renter_name.split(' ', 2).first,
      last_name: renter_name & renter_name.split(' ', 2).last,
      company: renter_company,
      street: renter_address,
      zip: renter_zip,
      city: renter_city,
    }
  end

  def rental_period
    room_rental_slots.map{|s| "#{s[:rent_date]} #{s[:hour_from]}-#{s[:hour_to]}"}.join(", ")
  end

  def calculate_price
    self.hourly_price = room_offer.room_rental_price.price_per_hour
    self.basic_price = total_hours * hourly_price
    if total_hours >= 8
      self.discount = (basic_price * room_offer.room_rental_price.eight_hour_discount.to_i / 100).round(2)
    else
      self.discount = 0
    end
    self.tax = ((basic_price - discount) * 0.20).round(2)
    self.service_fee = (total_price * 0.06).round(2) # 5% Imgraetzl fee + 20% tax
  end

  def total_hours
    room_rental_slots.sum(&:hours)
  end

  def total_price
    basic_price - discount + tax
  end

  def owner_payout_amount
    total_price - service_fee
  end

  def invoice_ready?
    payment_success? || payment_transfered?
  end

  def owner_invoice
    bucket = Aws::S3::Resource.new.bucket('invoices.imgraetzl.at')
    bucket.object("#{Rails.env}/room_rentals/#{id}-owner.pdf")
  end

  def renter_invoice
    bucket = Aws::S3::Resource.new.bucket('invoices.imgraetzl.at')
    bucket.object("#{Rails.env}/room_rentals/#{id}-renter.pdf")
  end
end
