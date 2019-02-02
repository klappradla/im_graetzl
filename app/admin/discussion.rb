ActiveAdmin.register Discussion do
  actions :index, :show, :destroy
  menu false

  show { render 'show', context: self }

end
