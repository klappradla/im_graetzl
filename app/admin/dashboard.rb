ActiveAdmin.register_page "Dashboard" do
  menu priority: 1

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel 'Neu registrierte User' do
          table_for User.order(created_at: :desc).limit(10) do
            column :id
            column :username do |user|
              link_to user.username, admin_user_path(user)
            end
            column :graetzl
            column :created_at
          end
          span do
            link_to 'Alle anzeigen', '/admin/users', class: 'btn-light'
          end
        end
      end
      column do
        panel 'Offene Location Anfragen' do
          table_for Location.pending.order(updated_at: :asc) do
            column(:location, sortable: :name) do |location|
              link_to location.name, admin_location_path(location)
            end
            column :graetzl
            column :users do |location|
              location.users.map do |user|
                link_to user.username, admin_user_path(user)
              end
            end
            column('status') { |location| status_tag(location.state) }
          end
          span do
            link_to 'Offene Anfragen Bearbeiten', '/admin/locations?scope=pending', class: 'btn-light'
          end
        end
      end
    end
  end
end
