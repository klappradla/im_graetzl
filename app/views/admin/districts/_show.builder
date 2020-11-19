context.instance_eval do
  columns do
    column do
      panel 'Basic Details' do
        attributes_table_for district do
          row :id
          row :zip
          row :name
          row :slug
          row :created_at
          row :updated_at
          row :area
        end
      end
    end
  end
end
