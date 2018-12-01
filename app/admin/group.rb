ActiveAdmin.register Group do
  include ViewInApp
  menu parent: 'Gruppe'
  actions :index, :show, :edit, :update, :destroy

  filter :users, collection: User.order(:last_name), include_blank: true, input_html: { :class => 'admin-filter-select'}
  filter :title
  filter :private
  filter :created_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params group_users_attributes: [:id, :user_id, :role, :_destroy]
end
