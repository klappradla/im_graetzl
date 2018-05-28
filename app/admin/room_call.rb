ActiveAdmin.register RoomCall do
  include ViewInApp

  menu parent: 'Raumteiler'
  form partial: 'form'

  permit_params :title, :subtitle, :description, :starts_at, :ends_at, :opens_at, :status, :about_us,
    :about_partner, :slug, :total_vacancies, :user_id, :location_id,
    :first_name, :last_name, :website, :email, :phone, :avatar, :cover_photo,
    room_call_fields_attributes: [:id, :label, :_destroy],
    room_call_prices: [:id, :name, :description, :amount, :keywords, :_destroy],
    room_call_modules: [:id, :room_module_id, :quantity, :_destroy],
    address_attributes: [:id, :_destroy, :street_name, :street_number, :zip, :city, :coordinates, :description],
    images_attributes: [:id, :file, :_destroy]
end
