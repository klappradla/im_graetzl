ActiveAdmin.register Group do
  menu parent: 'Gruppe'
  actions :index, :show, :edit, :update, :destroy

  show { render 'show', context: self }
  form partial: 'form'

  permit_params group_users_attributes: [:id, :user_id, :role, :_destroy]
end
