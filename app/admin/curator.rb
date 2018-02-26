ActiveAdmin.register Curator do
  menu parent: 'Weitere Einstellungen'
  filter :user
  filter :graetzl
  filter :website
  filter :description

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :graetzl_id, :user_id, :website, :name
end
