ActiveAdmin.register Graetzl do
  include ViewInApp
  menu priority: 2
  includes :districts

  filter :name
  filter :users_count

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
      def apply_pagination(chain)
          chain = super unless formats.include?(:json) || formats.include?(:csv)
          chain
      end
  end

  permit_params :name, :slug, :area
end
