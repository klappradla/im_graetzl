ActiveAdmin.register GoingTo do
  menu parent: 'Treffen'
  includes :meeting, :user
  actions :all, except: [:new, :create, :destroy]

  scope :paid_attendee, default: true
  scope :payment_success
  scope :payment_pending
  scope :payment_failed
  scope :payment_refunded

  filter :created_at
  filter :meeting, collection: proc { Meeting.where.not(amount: nil).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select' }

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :role, :payment_status

end
