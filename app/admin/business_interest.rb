ActiveAdmin.register BusinessInterest do
  menu parent: 'Users', priority: 2

  permit_params :title
end
