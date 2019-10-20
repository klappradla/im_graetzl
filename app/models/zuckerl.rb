class Zuckerl < ApplicationRecord
  extend FriendlyId
  include AASM
  include ActionView::Helpers

  attachment :image, type: :image
  friendly_id :title
  attr_accessor :active_admin_requested_event

  belongs_to :location
  has_one :graetzl, through: :location
  belongs_to :initiative

  after_commit :send_booking_confirmation, on: :create, if: proc {|zuckerl| zuckerl.pending?}

  validates :title, length: { in: 4..80 }

  scope :all_districts, -> { where(all_districts: true) }
  scope :marked_as_paid, -> { where("paid_at IS NOT NULL") }
  scope :this_month, lambda {where("created_at > ? AND created_at < ?", Time.now.beginning_of_month - 1.month, Time.now.end_of_month - 1.month)}
  scope :next_month, lambda {where("created_at > ? AND created_at < ?", Time.now.beginning_of_month, Time.now.end_of_month)}


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

  def self.next_invoice_number
    Zuckerl.where("invoice_number IS NOT NULL").count + 1
  end

  def basic_price
    if self.all_districts
      ZuckerlsHelper::ZuckerlAllDistrictsPrice
    else
      ZuckerlsHelper::ZuckerlGraetzlPrice
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

  def visibility
    if self.all_districts
      "Ganz Wien"
    else
      "#{self.location.graetzl.name} und gesamter #{self.location.districts.first.numeric}. Bezirk"
    end
  end

  def zuckerl_invoice
    bucket = Aws::S3::Resource.new.bucket('invoices.imgraetzl.at')
    bucket.object("#{Rails.env}/zuckerls/#{id}-zuckerl.pdf")
  end

  private

  def send_booking_confirmation
    AdminMailer.new_zuckerl(self).deliver_later
    ZuckerlMailer.booking_confirmation(self).deliver_later
  end

  def send_live_information
    ZuckerlMailer.live_information(self).deliver_later
  end

  def generate_invoice(zuckerl)
    zuckerl_invoice = ZuckerlInvoice.new.invoice(zuckerl)
    zuckerl.zuckerl_invoice.put(body: zuckerl_invoice)
  end

  def send_invoice
    invoice_number = "#{Date.current.year}/Zuckerl-#{self.id}/Nr-#{Zuckerl.next_invoice_number}"
    update(invoice_number: invoice_number)
    update(paid_at: Time.now)
    generate_invoice(self)
    ZuckerlMailer.invoice(self).deliver_later
  end

end
