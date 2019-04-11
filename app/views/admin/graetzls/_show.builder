context.instance_eval do
  columns do
    column do
      panel 'Basic Details' do
        attributes_table_for graetzl do
          row :id
          row :name
          row :slug
          row :created_at
          row :updated_at
          row :area
        end
      end
      if graetzl.curator
        panel 'Grätzlbotschafter' do
          attributes_table_for graetzl.curator do
            row :id
            row :user
            row :created_at
          end
        end
      end
    end
    column span: 2 do
      panel 'Associations' do
        tabs do
          tab 'User' do
            table_for graetzl.users do
              column :id
              column :username
              column :email
              column :last_sign_in_at
              column(''){|u| link_to 'Anzeigen', admin_user_path(u) }
            end
          end
          tab 'Treffen' do
            table_for graetzl.meetings do
              column :id
              column :name
              column :slug
              column :user
              column :created_at
              column(''){|m| link_to 'Anzeigen', admin_meeting_path(m) }
            end
          end
          tab 'Locations' do
            table_for graetzl.locations do
              column :id
              column :name
              column(:state){|l| status_tag(l.state)}
              column :slug
              column :created_at
              column(''){|l| link_to 'Anzeigen', admin_location_path(l) }
            end
          end
        end
      end
    end
  end
end
