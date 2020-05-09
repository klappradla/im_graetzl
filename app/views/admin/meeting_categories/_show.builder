context.instance_eval do
  columns do
    column do
      attributes_table do
        row :id
        row :title
        row :icon
        row :created_at
      end
    end
    column span: 2 do
      panel 'Associations' do
        tabs do
          tab 'Meetings' do
            table_for meeting_category.meetings do
              column :id
              column :name
              column(''){|m| link_to 'Anzeigen', admin_meeting_path(m) }
            end
          end
        end
      end
    end
  end
end
