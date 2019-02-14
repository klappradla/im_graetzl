ActiveAdmin.register BusinessInterest do
  menu parent: 'Users', priority: 2

  form partial: 'form'

  permit_params :title, :mailchimp_id
end
