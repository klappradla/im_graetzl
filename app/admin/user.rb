ActiveAdmin.register User do
  include ViewInApp
  menu priority: 3
  includes :graetzl, :location_category, :business_interests

  scope :all, default: true
  scope :business
  scope :admin

  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select' }
  filter :districts, collection: proc { District.order(:zip).pluck(:zip, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :id, label: 'User', as: :select, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location_category, collection: proc { LocationCategory.pluck(:name, :id) }, include_blank: true
  filter :business_interests, collection: proc { BusinessInterest.pluck(:title, :id) }, include_blank: true
  filter :first_name
  filter :last_name
  filter :email
  filter :origin
  filter :created_at
  filter :last_sign_in_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :graetzl_id,
    :username,
    :first_name,
    :last_name,
    :email,
    :password,
    :newsletter,
    :bio,
    :website,
    :avatar, :remove_avatar,
    :cover_photo, :remove_cover_photo,
    :role,
    :business,
    :location_category,
    :business_interests,
    address_attributes: [
      :id,
      :street_name,
      :street_number,
      :zip,
      :city,
      :description,
      :coordinates]

    # Within app/admin/resource_name.rb
    # Controller pagination overrides
    controller do
        def apply_pagination(chain)
            chain = super unless formats.include?(:json) || formats.include?(:csv)
            chain
        end
    end

    csv do
      #column :created_at
      #column :id
      column :email
      #column :username
      column :first_name
      column :last_name
      #column(:business) {|user| user.business? ? 'business' : '' }
      #column :newsletter
      #column (:plz) { |user| user.address.zip if user.address}

      #column(:plz) { |user| user.district.try(:zip) }
      #column(:graetzl) { |user| user.graetzl.name }
      #column(:location_category) {|user| user.location_category.try(:name) }
      #column(:location) { |user| user.primary_location.try(:name) }
      #column(:location_bezirk) { |user|
      #  user.primary_location.graetzl.districts.first.try(:zip) if user.primary_location
      #}
      #column(:location_graetzl) { |user|
      #  user.primary_location.graetzl.name if user.primary_location
      #}
      #column(:meetings_initiated) { |user| user.initiated_meetings.count }
      #column(:location_posts) { |user| user.location_posts.count }
    end
end
