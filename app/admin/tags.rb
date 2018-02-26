ActiveAdmin.register ActsAsTaggableOn::Tag, as: 'Tag' do
  actions :index, :show, :update, :edit, :destroy
  menu parent: :locations
  config.filters = false

  index { render 'index', context: self }
  show { render 'show', context: self }

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
