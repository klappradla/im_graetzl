ActiveAdmin.register LocationOwnership do
  #menu parent: 'Locations', label: 'Location-Inhaber'
  menu false

  #index { render 'index', context: self }

  form do
    inputs '' do
      input :user
      input :location
      input :state
    end
  end


  # scope 'Alle', :all, default: true
  # scope 'Offene Mitarbeiter Anfragen', :requested
  # scope :pending
  # scope :approved

  # index do
  #   selectable_column
  #   column('ID', sortable: :id) do |ownership|
  #     link_to "##{ownership.id} ", admin_location_ownership_path(ownership)
  #   end
  #   column(:location) do |ownership|
  #     link_to ownership.location.name, admin_location_path(ownership.location)
  #   end
  #   column(:user) do |ownership|
  #     link_to ownership.user.username, admin_user_path(ownership.user_id)
  #   end
  #   column('Status') do |ownership|
  #     status_tag(ownership.state)
  #   end
  #   column('Letztes Update', :updated_at)
  # end


  # # batch actions
  # batch_action :approve do |ids|
  #   batch_action_collection.find(ids).each do |ownership|
  #     if ownership.may_approve?
  #       ownership.approve!
  #     end
  #   end
  #   redirect_to collection_path, alert: 'Die Anfragen wurden approved.'
  # end


  # # action buttons
  # action_item :view, only: :show do
  #   link_to 'Approve', approve_admin_location_ownership_path(location_ownership), class: 'approve'
  # end


  # # custom member actions
  # member_action :approve, method: :get do
  #   if resource.may_approve?
  #     resource.approve!
  #     flash[:success] = 'Inhaberanfrage wurde approved.'
  #     redirect_to resource_path
  #   else
  #     flash[:error] = 'Inhaberanfrage kann nicht approved werden'
  #     redirect_to resource_path
  #   end
  # end
end
