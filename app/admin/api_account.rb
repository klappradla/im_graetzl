ActiveAdmin.register ApiAccount do
  menu parent: 'Einstellungen'

  config.filters = false

  permit_params :name, :api_key, :enabled
end
