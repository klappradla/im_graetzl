ActiveAdmin.register RoomCallSubmission do
  actions :index, :show, :destroy
  menu parent: 'Raumteiler'

  show { render 'show', context: self }

end
