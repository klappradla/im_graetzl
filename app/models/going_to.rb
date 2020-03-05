class GoingTo < ApplicationRecord
  include Trackable
  belongs_to :user
  belongs_to :meeting
  belongs_to :meeting_additional_date

  enum role: { attendee: 0, initiator: 1, paid_attendee: 2 }
  enum payment_status: { payment_pending: 0, payment_success: 1, payment_failed: 2, payment_refunded: 3 }

  PAYMENT_METHODS = ['card', 'eps'].freeze

  def amount_netto
    (amount / 1.20).round(2)
  end

  def tax
    (amount_netto * 0.20).round(2)
  end

  def display_starts_at_date
    if self.meeting_additional_date_id.present?
      meeting_additional_date = MeetingAdditionalDate.find(self.meeting_additional_date_id)
      meeting_additional_date.display_starts_at_date
    else
      self.meeting.display_starts_at_date
    end
  end

  def self.next_invoice_number
    GoingTo.where("invoice_number IS NOT NULL").count + 1
  end

  def invoice
    bucket = Aws::S3::Resource.new.bucket('invoices.imgraetzl.at')
    bucket.object("#{Rails.env}/going_tos/#{id}.pdf")
  end

end
