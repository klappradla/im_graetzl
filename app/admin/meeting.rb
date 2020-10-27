ActiveAdmin.register Meeting do
  include ViewInApp
  menu priority: 5
  menu parent: 'Treffen'
  includes :graetzl, :location

  scope :all, default: true
  scope :upcoming
  #scope 'Online Event', :online_meeting
  scope 'SFS approved', :platform_meeting
  scope 'SFS pending', :platform_meeting_pending
  scope 'SFS processing', :platform_meeting_processing
  scope 'SFS declined', :platform_meeting_declined
  #scope :active
  #scope :cancelled

  filter :event_categories
  filter :meeting_category, collection: proc { MeetingCategory.order(:starts_at_date).pluck(:title, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :graetzl, collection: proc { Graetzl.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :users, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :location, collection: proc { Location.order(:name).pluck(:name, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}
  #filter :state, as: :select, collection: Meeting.states.keys, input_html: { class: 'admin-filter-select'}
  filter :name
  filter :description
  filter :created_at
  #filter :starts_at_date
  filter :platform_meeting
  filter :online_meeting

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  # batch actions
  batch_action :approve_for_api do |ids|
    batch_action_collection.find(ids).map(&:approve_for_api)
    redirect_to collection_path, alert: 'Die gewählten Treffen wurden für die API genehmigt.'
  end

  batch_action :disapprove_for_api, confirm: 'Wirklich aus API entfernen?' do |ids|
    batch_action_collection.find(ids).map(&:disapprove_for_api)
    redirect_to collection_path, alert: 'Die gewählten Treffen werden für die API nicht mehr genehmigt.'
  end

  batch_action :approve_for_platform_meetings do |ids|
    batch_action_collection.find(ids).each do |meeting|
      if meeting.platform_meeting_join_request
        meeting.platform_meeting_join_request.assign_attributes(status: :approved)
      end
      meeting.platform_meeting = true
      meeting.save
    end
    redirect_to collection_path, alert: 'Die gewählten Treffen wurden zu den Platform-Treffen hinzugefügt'
  end

  batch_action :decline_for_platform_meetings do |ids|
    batch_action_collection.find(ids).each do |meeting|
      if meeting.platform_meeting_join_request
        meeting.platform_meeting_join_request.assign_attributes(status: :declined)
      end
      meeting.platform_meeting = false
      meeting.save
    end
    redirect_to collection_path, alert: 'Die gewählten Treffen wurden abgelehnt'
  end

  batch_action :process_for_platform_meetings do |ids|
    batch_action_collection.find(ids).each do |meeting|
      if meeting.platform_meeting_join_request
        meeting.platform_meeting_join_request.assign_attributes(status: :processing)
      end
      meeting.platform_meeting = false
      meeting.save
    end
    redirect_to collection_path, alert: 'Die gewählten Treffen wurden als in Bearbeitung markiert'
  end

  # action buttons
  action_item :approve_for_api, only: :show, if: proc{ !meeting.approved_for_api? } do
    link_to 'API genehmigen', approve_for_api_admin_meeting_path(meeting), { method: :put }
  end

  action_item :disapprove_for_api, only: :show, if: proc{ meeting.approved_for_api? } do
    link_to 'API entfernen', disapprove_for_api_admin_meeting_path(meeting), { method: :put }
  end

  action_item :approve_for_platform_meeting, only: :show, if: proc{ meeting.platform_meeting_pending? } do
    link_to 'Freischalten für SFS', approve_for_platform_meeting_admin_meeting_path(meeting), { method: :put }
  end

  action_item :decline_for_platform_meeting, only: :show, if: proc{ meeting.platform_meeting_pending? } do
    link_to 'Ablehnen für SFS', decline_for_platform_meeting_admin_meeting_path(meeting), { method: :put }
  end

  action_item :process_for_platform_meeting, only: :show, if: proc{ meeting.platform_meeting_pending? } do
    link_to 'In Bearbeitung für SFS', process_for_platform_meeting_admin_meeting_path(meeting), { method: :put }
  end

  # member actions
  member_action :approve_for_platform_meeting, method: :put do
    resource.platform_meeting_join_request.assign_attributes(status: :approved)
    resource.platform_meeting = true
    resource.save
    flash[:success] = 'Das Treffen wurde freigeschalten.'
    redirect_to admin_meetings_path
  end

  member_action :decline_for_platform_meeting, method: :put do
    resource.platform_meeting_join_request.assign_attributes(status: :declined)
    resource.platform_meeting = false
    resource.save
    flash[:error] = 'Das Treffen wurde abgelehnt.'
    redirect_to admin_meetings_path
  end

  member_action :process_for_platform_meeting, method: :put do
    resource.platform_meeting_join_request.assign_attributes(status: :processing)
    resource.platform_meeting = false
    resource.save
    flash[:success] = 'Das Treffen wurde als in Bearbeitung markiert.'
    redirect_to admin_meetings_path
  end

  member_action :approve_for_api, method: :put do
    if resource.approve_for_api
      flash[:success] = 'Das Treffen wurde für die API genehmigt.'
      redirect_to admin_meetings_path
    else
      flash[:error] = 'Das Treffen kann für die API nicht genehmigt werden.'
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

  csv do
    column(:email) {|m| m.user.email }
    column(:full_name) {|m| m.user.full_name }
    column :user_id
    column :id
    column(:category) {|m| m.meeting_category.title if m.meeting_category}
    column :name
    column(:going_tos) {|m| m.going_tos.count }
    column(:meeting_url) { |m| graetzl_meeting_url(m.graetzl, m)}
    column :created_at
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
    :group_id,
    :user_id,
    :meeting_category_id,
    :approved_for_api,
    :platform_meeting,
    :online_meeting,
    event_category_ids: [],
    address_attributes: [
      :id,
      :street_name,
      :street_number,
      :zip,
      :city,
      :coordinates,
      :description,
      :online_meeting_description],
    going_tos_attributes: [
      :id,
      :user_id,
      :role,
      :meeting_additional_date_id,
      :_destroy]
end
