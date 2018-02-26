ActiveAdmin.register Initiative do
  menu parent: 'Weitere Einstellungen'
  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  filter :graetzls
  filter :zuckerls
  filter :name
  filter :description
  filter :website

  permit_params :name,
    :description,
    :website,
    :image, :remove_image,
    graetzl_ids: []
end
