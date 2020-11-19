ActiveAdmin.register District do
  include ViewInApp
  menu parent: 'Grätzl', priority: 1
  includes :graetzls
  actions :all, except: [:new, :create, :destroy]

  filter :zip
  filter :name

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'


  permit_params :name, :area
end
