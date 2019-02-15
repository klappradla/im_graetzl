ActiveAdmin.register BusinessInterest do
  menu parent: 'Users', priority: 2

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title, :mailchimp_id
end
