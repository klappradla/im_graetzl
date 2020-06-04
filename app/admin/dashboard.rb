ActiveAdmin.register_page "Dashboard" do
  menu priority: 1

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Neue User" do
          table_for User.order(created_at: :desc).limit(10) do
            column :id
            column :username do |user|
              link_to user.username, admin_user_path(user)
            end
            column :graetzl
            column :created_at
          end
          span do
            link_to 'Alle User anzeigen', admin_users_path, class: 'btn-light'
          end
        end
        panel 'Offene Platform Treffen Anfragen' do

          tabs do
            tab 'Pending' do
              table_for Meeting.platform_meeting_pending.order(updated_at: :asc) do
                column(:meeting, sortable: :name) do |meeting|
                  link_to meeting.name, admin_meeting_path(meeting)
                end
                column('status') { |meeting| status_tag(meeting.platform_meeting_join_request.status) }
                column :users do |meeting|
                  link_to(meeting.user.username, admin_user_path(meeting.user))
                end
                column :meeting_category
              end
              span do
                link_to 'Offene Anfragen Bearbeiten', admin_meetings_path(:scope => 'platform_meeting_pending'), class: 'btn-light'
              end
            end

            tab 'Processing' do
              table_for Meeting.platform_meeting_processing.order(updated_at: :asc) do
                column(:meeting, sortable: :name) do |meeting|
                  link_to meeting.name, admin_meeting_path(meeting)
                end
                column('status') { |meeting| status_tag(meeting.platform_meeting_join_request.status) }
                column :users do |meeting|
                  link_to(meeting.user.username, admin_user_path(meeting.user))
                end
                column :meeting_category
              end
              span do
                link_to 'Offene Anfragen Bearbeiten', admin_meetings_path(:scope => 'platform_meeting_processing'), class: 'btn-light'
              end
            end

            tab 'Declined' do
              table_for Meeting.platform_meeting_declined.order(updated_at: :asc) do
                column(:meeting, sortable: :name) do |meeting|
                  link_to meeting.name, admin_meeting_path(meeting)
                end
                column('status') { |meeting| status_tag(meeting.platform_meeting_join_request.status) }
                column :users do |meeting|
                  link_to(meeting.user.username, admin_user_path(meeting.user))
                end
                column :meeting_category
              end
              span do
                link_to 'Offene Anfragen Bearbeiten', admin_meetings_path(:scope => 'platform_meeting_declined'), class: 'btn-light'
              end
            end
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
              safe_join(location.users.map { |user| link_to(user.username, admin_user_path(user)) }, ', ')
            end
            column('status') { |location| status_tag(location.state) }
          end
          span do
            link_to 'Offene Anfragen Bearbeiten', admin_locations_path(:scope => 'pending'), class: 'btn-light'
          end
        end
      end
    end
  end
end
