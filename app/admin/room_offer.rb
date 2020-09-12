ActiveAdmin.register RoomOffer do
  include ViewInApp
  menu parent: 'Raumteiler'
  includes :graetzl, :location, :user, :comments
  actions :all, except: [:new, :create]

  scope :enabled, default: true
  scope :rentable
  scope :reactivated
  scope :disabled
  scope :occupied
  scope :all

  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :district, collection: proc { District.order(:zip) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :user, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location, collection: proc { Location.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :room_categories
  filter :wants_collaboration
  filter :created_at
  filter :updated_at
  filter :last_activated_at

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

  csv do
    column :id
    column(:email) {|r| r.user.email if r.user }
    column(:full_name) {|r| r.user.full_name if r.user }
    column :user_id

    #column :created_at
    #column :last_activated_at
    column(:district) { |room_offer| room_offer.district.try(:zip) }
    #column(:graetzl)  { |room_offer| room_offer.graetzl.name }

    column(:room_categories) { |g|
      g.room_categories.map { |category|
        category.name
      }
    }

    column :slogan
    #column :room_description
    #column :total_area
    #column :rented_area
    column :wants_collaboration
    #column :owner_description
    #column :tenant_description

    #column(:room_offer_prices) { |g|
    #  g.room_offer_prices.map { |price|
    #    "#{price.amount} - #{price.name}"
    #  }
    #}

    #column(:keyword_list) { |g|
    #  g.keyword_list.map { |keyword|
    #    keyword
    #  }
    #}

  end

end
