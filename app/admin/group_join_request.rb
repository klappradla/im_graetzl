ActiveAdmin.register GroupJoinRequest do
  menu parent: 'Gruppe', priority: 4
  includes :user

  scope :all, default: true
  scope :pending
  scope :accepted
  scope :rejected

  filter :user, collection: proc { User.admin_select_collection }, include_blank: true, input_html: { class: 'admin-filter-select'}
  filter :group, collection: proc { Group.order(:title).pluck(:title, :id) }, include_blank: true, input_html: { class: 'admin-filter-select'}

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :group_id, :status
end
