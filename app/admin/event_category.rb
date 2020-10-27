ActiveAdmin.register EventCategory do
  menu parent: 'Treffen'
  config.filters = false

  scope :all, default: true

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title, :main_photo, :remove_main_photo, :position, :css_ico_class

end
