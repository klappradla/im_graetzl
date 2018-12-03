ActiveAdmin.register GroupCategory do
  menu parent: 'Gruppe', priority: 2

  permit_params :title
end
