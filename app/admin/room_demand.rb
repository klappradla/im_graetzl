ActiveAdmin.register RoomDemand do
  include ViewInApp
  menu parent: 'Raumteiler'
  includes :location, :user, :comments
  actions :all, except: [:new, :create]

  scope :enabled, default: true
  scope :reactivated
  scope :disabled
  scope :all

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
    :first_name, :last_name, :website, :email, :phone, :status, graetzl_ids: [],
    room_category_ids: []
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
    #column :user_id
    #column :created_at
    #column :last_activated_at

    column(:districts) { |g|
      g.districts.map { |district|
        district.try(:zip)
      }
    }

    #column(:graetzls) { |g|
    #  g.graetzls.map { |graetzl|
    #    graetzl.name
    #  }
    #}

    #column(:room_categories) { |g|
    #  g.room_categories.map { |category|
    #    category.name
    #  }
    #}

    column :slogan
    #column :demand_description
    #column :needed_area
    #column :wants_collaboration
    #column :personal_description

    #column(:keyword_list) { |g|
    #  g.keyword_list.map { |keyword|
    #    keyword
    #  }
    #}

  end

end
