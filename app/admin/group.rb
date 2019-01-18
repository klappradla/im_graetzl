ActiveAdmin.register Group do
  include ViewInApp
  menu parent: 'Gruppe', priority: 1

  actions :index, :show, :edit, :update, :destroy

  includes :graetzls, group_users: :user

  scope :all, default: true
  scope :featured

  filter :users, collection: proc {User.admin_select_collection}, include_blank: true, input_html: {class: 'admin-filter-select'}
  filter :graetzls, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :districts, collection: proc { District.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :group_categories
  filter :title
  filter :private
  filter :created_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title, :description, :featured, :hidden, :private, :room_offer_id, :room_demand_id,
    :room_call_id, :location_id, :cover_photo, :remove_cover_photo, graetzl_ids: [],
    group_category_ids: [], group_users_attributes: [:id, :user_id, :role, :_destroy]
end
