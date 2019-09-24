ActiveAdmin.register ToolOffer do
  include ViewInApp
  menu parent: 'Toolteiler'
  includes :graetzl, :location, :user, :comments
  actions :all, except: [:new, :create, :destroy]

  scope :all, default: true

  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :user, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location, collection: proc { Location.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :tool_categories
  filter :created_at
  filter :updated_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title, :description, :brand, :model, :status, :keyword_list,
    :value_up_to, :serial_number, :known_defects,
    :price_per_day, :two_day_discount, :weekly_discount,
    :tool_category_id, :tool_subcategory_id, :location_id,
    :cover_photo, :remove_cover_photo,
    :first_name, :last_name, :iban,
    images_files: [],
    images_attributes: [:id, :_destroy],
    address_attributes: [
      :id, :street_name, :street_number, :zip, :city
    ]

  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
