class RoomRental < ApplicationRecord
  include Trackable
  belongs_to :user
  belongs_to :room_offer

  has_many :room_rental_slots
  accepts_nested_attributes_for :room_rental_slots, allow_destroy: true, reject_if: proc { |attrs|
    attrs['hour_from'].blank? || attrs['hour_to'].blank? || attrs['hour_to'].to_i <= attrs['hour_from'].to_i
  }

  has_one :user_message_thread

  enum rental_status: { incomplete: 0, pending: 1, canceled: 2, rejected: 3, approved: 4, expired: 5 }
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
      first_name: renter_name && renter_name.split(' ', 2).first,
      last_name: renter_name && renter_name.split(' ', 2).last,
      company: renter_company,
      street: renter_address,
      zip: renter_zip,
      city: renter_city,
    }
  end

  def rental_period
    room_rental_slots.map{|s| "#{I18n.l(s.rent_date, format: :short)}, #{s.hour_from}-#{s.hour_to} Uhr"}.join(", ")
  end

  def rental_start
    room_rental_slots.map(&:rent_date).min
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
    self.service_fee = basic_service_fee + service_fee_tax
  end

  def total_hours
    room_rental_slots.sum(&:hours)
  end

  def total_price
    basic_price - discount + tax
  end

  def basic_service_fee
    (basic_price * 0.07).round(2)
  end

  def service_fee_tax
    (basic_service_fee * 0.2).round(2)
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
