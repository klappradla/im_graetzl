ActiveAdmin.register RoomModule do
  include ViewInApp

  menu parent: 'Raumteiler'
  form partial: 'form'

  permit_params :name, :icon, :description
end
