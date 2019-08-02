ActiveAdmin.register ToolCategory do
  menu parent: 'Toolteiler'

  permit_params :name, :parent_category_id

  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
