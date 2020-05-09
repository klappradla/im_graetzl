ActiveAdmin.register MeetingCategory do
  menu parent: 'Treffen'
  config.filters = false

  scope :all, default: true

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title, :icon, :starts_at_date, :ends_at_date
  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do

    def index
      params[:order] = "starts_at_date_asc"
      super
    end

    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end

  end
end
