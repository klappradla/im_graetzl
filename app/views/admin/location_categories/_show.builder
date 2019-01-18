context.instance_eval do
  columns do
    column do
      attributes_table do
        row :id
        row :name
        row :icon
        row(:context){|c| status_tag(c.context)}
        row :created_at
      end
    end
    column span: 2 do
      panel 'Associations' do
        tabs do
          tab 'Locations' do
            table_for location_category.locations do
              column :id
              column :name
              column(:state){|l| status_tag(l.state)}
              column(''){|l| link_to 'Anzeigen', admin_location_path(l) }
            end
          end
        end
      end
    end
  end
end
