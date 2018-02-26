ActiveAdmin.register RoomSuggestedTag do
  menu parent: 'Raumteiler'

  permit_params :name

  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
