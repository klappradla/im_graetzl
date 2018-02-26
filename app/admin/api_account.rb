ActiveAdmin.register ApiAccount do
  menu parent: 'Weitere Einstellungen'

  config.filters = false

  permit_params :name, :api_key, :enabled
end
