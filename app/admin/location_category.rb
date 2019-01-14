ActiveAdmin.register LocationCategory do
  menu parent: :locations
  config.filters = false

  scope :all, default: true
  scope :business
  scope :recreation

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :name, :icon, :context
  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
