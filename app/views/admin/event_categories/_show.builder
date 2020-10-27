context.instance_eval do
  columns do
    column do
      attributes_table do
        row :id
        row :title
        row :position
        row :css_ico_class
        row :created_at
      end
    end
    column span: 2 do
      panel 'Meetings' do
        table_for event_category.meetings do
          column :id
          column :name
          column(''){|m| link_to 'Anzeigen', admin_meeting_path(m) }
        end
      end
    end
  end
end
