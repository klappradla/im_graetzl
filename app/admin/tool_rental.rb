ActiveAdmin.register ToolRental do
  menu parent: 'Toolteiler'
  includes :tool_offer, :user
  actions :all, except: [:new, :create, :edit, :update]

  scope :all, default: true

  filter :rental_status, as: :select, collection: ToolRental.rental_statuses.keys
  filter :payment_status, as: :select, collection: ToolRental.payment_statuses.keys
  filter :tool_offer, collection: proc { ToolOffer.order(:title).pluck(:title, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :user, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :created_at
  filter :updated_at

  index { render 'index', context: self }
  show { render 'show', context: self }

  action_item :payment_transfered, only: :show, if: proc{ tool_rental.payment_success? } do
    link_to 'Payment Transfered to Renter', payment_transfered_admin_tool_rental_path(tool_rental), { method: :patch }
  end

  # member actions
  member_action :payment_transfered, method: :patch do
    resource.payment_transfered!
    flash[:success] = 'Payment marked as transfered.'
    redirect_to admin_tool_rentals_path
  end

end
