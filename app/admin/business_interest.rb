ActiveAdmin.register BusinessInterest do
  menu parent: 'Users', priority: 2

  form partial: 'form'

  permit_params :title
  permit_params :mailchimp_id
end
