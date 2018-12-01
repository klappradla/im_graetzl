ActiveAdmin.register RoomOffer do
  include ViewInApp
  menu parent: 'Raumteiler'
  includes :graetzl, :location, :user, :comments
  actions :all, except: [:new, :create]

  scope :all, default: true

  filter :graetzl, collection: Graetzl.order(:name), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :district, collection: District.order(:zip), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :user, collection: User.order(:username), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :location, collection: Location.order(:name), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :room_categories
  filter :wants_collaboration
  filter :created_at
  filter :updated_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :user_id, :slogan, :graetzl_id, :district_id, :location_id, :room_description, :total_area,
    :rented_area, :owner_description, :tenant_description, :wants_collaboration, :keyword_list,
    :slug, :offer_type, :cover_photo, :remove_cover_photo, :avatar, :remove_avatar,
    :first_name, :last_name, :website, :email, :phone, :status,
    room_offer_price_ids: [],
    room_category_ids: [],
    address_attributes: [ :id, :_destroy, :street_name, :street_number, :zip, :city, :coordinates, :description],
    room_offer_prices_attributes: [ :id, :name, :amount, :_destroy],
    images_attributes: [:id, :file, :_destroy]
  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
