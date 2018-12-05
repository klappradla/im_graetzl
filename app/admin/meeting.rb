ActiveAdmin.register Meeting do
  include ViewInApp
  menu priority: 5
  includes :graetzl, :location

  scope :all, default: true
  scope :active
  scope :cancelled
  scope :upcoming

  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :users, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location, collection: proc { Location.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :state, as: :select, collection: Meeting.states.keys
  filter :name
  filter :description
  filter :created_at
  filter :starts_at_date

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  # batch actions
  batch_action :approve_for_api do |ids|
    batch_action_collection.find(ids).map(&:approve_for_api)
    redirect_to collection_path, alert: 'Die ausgewählten Treffen wurden für die API genehmigt.'
  end

  batch_action :disapprove_for_api, confirm: 'Wirklich aus API entfernen?' do |ids|
    batch_action_collection.find(ids).map(&:disapprove_for_api)
    redirect_to collection_path, alert: 'Die gewählten Treffen werden für die API nicht mehr genehmigt.'
  end

  # action buttons
  action_item :approve_for_api, only: :show, if: proc{ !meeting.approved_for_api? } do
    link_to 'Treffen für API genehmigen', approve_for_api_admin_meeting_path(meeting), { method: :put }
  end

  action_item :disapprove_for_api, only: :show, if: proc{ meeting.approved_for_api? } do
    link_to 'Treffen für API nicht genehmigen', disapprove_for_api_admin_meeting_path(meeting), { method: :put }
  end

  # member actions
  member_action :approve_for_api, method: :put do
    if resource.approve_for_api
      flash[:success] = 'Das Treffen wurde für die API genehmigt.'
      redirect_to admin_meetings_path
    else
      flash[:error] = 'Das Treffen kan für die API nicht genehmigt werden.'
      redirect_to resource_path
    end
  end

  member_action :disapprove_for_api, method: :put do
    if resource.disapprove_for_api
      flash[:notice] = 'Das Treffen ist nicht mehr für die API genehmigt.'
      redirect_to admin_meetings_path
    else
      flash[:error] = 'Das Treffen kann nicht für die API abgelehnt werden.'
      redirect_to resource_path
    end
  end

  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
      def apply_pagination(chain)
          chain = super unless formats.include?(:json) || formats.include?(:csv)
          chain
      end
  end

  permit_params :graetzl_id,
    :name,
    :slug,
    :state,
    :description,
    :cover_photo, :remove_cover_photo,
    :starts_at_date, :starts_at_time,
    :ends_at_time,
    :location_id,
    :approved_for_api,
    address_attributes: [
      :id,
      :street_name,
      :street_number,
      :zip,
      :city,
      :coordinates,
      :description],
    going_tos_attributes: [
      :id,
      :user_id,
      :role,
      :_destroy]
end
