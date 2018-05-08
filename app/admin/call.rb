ActiveAdmin.register Call do
  include ViewInApp

  before_save do |call|
    call.group = call.room_offer.group
  end

  menu parent: 'Raumteiler'
  form partial: 'form'

  permit_params :title, :description, :room_offer_id, :starts_at, :ends_at,
    call_fields_attributes: [:id, :label, :_destroy]

end
