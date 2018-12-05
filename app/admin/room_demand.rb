ActiveAdmin.register RoomDemand do
  include ViewInApp
  menu parent: 'Raumteiler'
  includes :location, :user, :comments
  actions :all, except: [:new, :create]

  scope :all, default: true

  filter :graetzls, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :districts, collection: proc { District.order(:zip) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :user, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location, collection: proc { Location.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :room_categories
  filter :wants_collaboration
  filter :created_at
  filter :updated_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :user_id, :slogan, :location_id, :needed_area, :demand_description,
    :personal_description, :wants_collaboration, :demand_type, :slug, :avatar, :remove_avatar,
    :first_name, :last_name, :website, :email, :phone, :status,
    room_category_ids: []
  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
