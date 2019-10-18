class Zuckerl < ApplicationRecord
  extend FriendlyId
  include AASM
  include ActionView::Helpers::NumberHelper

  ZuckerlGraetzlPrice = 16.5
  ZuckerlAllDistrictsPrice = 190

  attachment :image, type: :image
  friendly_id :title
  attr_accessor :active_admin_requested_event

  belongs_to :location
  has_one :graetzl, through: :location
  belongs_to :initiative

  after_commit :send_booking_confirmation, on: :create, if: proc {|zuckerl| zuckerl.pending?}

  validates :title, length: { in: 4..80 }

  scope :all_districts, -> { where(all_districts: true) }

  aasm do
    state :pending, initial: true
    state :draft
    state :paid
    state :live
    state :cancelled
    state :expired

    event :mark_as_paid, guard: lambda { paid_at.blank? }, after: :send_invoice do
      transitions from: :pending, to: :paid
      transitions from: :live, to: :live
    end

    event :put_live, after: :send_live_information do
      transitions from: [:pending, :draft, :paid], to: :live
    end

    event :expire do
      transitions from: :live, to: :expired
    end

    event :cancel do
      transitions to: :cancelled
    end
  end

  def self.include_for_box
    includes(location: [:location_category, :address])
  end

  def payment_reference
    "#{model_name.singular}_#{id}_#{created_at.strftime('%y%m')}"
  end

  def basic_price
    if self.all_districts
      ZuckerlAllDistrictsPrice
    else
      ZuckerlGraetzlPrice
    end
  end

  def tax
    (basic_price * 0.20).round(2)
  end

  def total_price
    basic_price + tax
  end

  def basic_price_with_currency
    number_to_currency(basic_price)
  end

  def tax_with_currency
    number_to_currency(tax)
  end

  def total_price_with_currency
    number_to_currency(basic_price + tax)
  end

  def zuckerl_graetzl_price_with_curreny
    number_to_currency(ZuckerlGraetzlPrice + (ZuckerlGraetzlPrice * 0.20))
  end

  def zuckerl_all_districts_price_with_curreny
    number_to_currency(ZuckerlAllDistrictsPrice + (ZuckerlAllDistrictsPrice * 0.20))
  end

  def district_visibility
    if self.all_districts
      "Ganz Wien"
    else
      "#{self.location.graetzl.name} und gesamter #{self.location.districts.first.numeric}. Bezirk"
    end
  end

  private

  def send_booking_confirmation
    AdminMailer.new_zuckerl(self).deliver_later
    ZuckerlMailer.booking_confirmation(self).deliver_later
  end

  def send_invoice
    update(paid_at: Time.now)
    ZuckerlMailer.invoice(self).deliver_later
  end

  def send_live_information
    ZuckerlMailer.live_information(self).deliver_later
  end
end
