ActiveAdmin.register ToolOffer do
  include ViewInApp
  menu parent: 'Toolteiler'
  includes :graetzl, :location, :user, :comments
  actions :all, except: [:new, :create]

  scope :all, default: true

  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :user, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location, collection: proc { Location.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :tool_categories
  filter :created_at
  filter :updated_at

  index { render 'index', context: self }
  show { render 'show', context: self }

  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
