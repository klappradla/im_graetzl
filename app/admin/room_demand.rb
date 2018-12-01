ActiveAdmin.register RoomDemand do
  include ViewInApp
  menu parent: 'Raumteiler'
  includes :location, :user, :comments
  actions :all, except: [:new, :create]

  scope :all, default: true

  filter :graetzls, collection: Graetzl.order(:name), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :districts, collection: District.order(:zip), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :user, :collection => proc {(User.all).map{|c| [c.active_admin_name, c.id]}}, include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :location, collection: Location.order(:name), include_blank: true, input_html: { :class => 'admin-filter-select'}
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
