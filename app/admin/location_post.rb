ActiveAdmin.register LocationPost do
  menu parent: 'Locations'
  actions :all, except: [:new, :create]

  filter :author, as: :select, collection: -> { Location.all }
  filter :title
  filter :content
  filter :created_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title,
    :content,
    :graetzl_id,
    :author_id, :author_type,
    images_attributes: [:id, :file, :_destroy]
  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
