context.instance_eval do
  columns do
    column do
      panel 'Meeting Details' do
        attributes_table_for meeting do
          row :id
          row :name
          row :online_meeting
          row(:state){|m| status_tag(m.state)}
          row :event_categories do |e|
            safe_join(
              e.event_categories.map do |category|
                content_tag(:span, link_to(category.title, admin_room_category_path(category))) + ', '
              end
            )
          end
          row :slug
          row :created_at
          row :graetzl
          row :location
          row :group
          row :user
          row :description
          row :cover_photo do |m|
            m.cover_photo ? attachment_image_tag(m, :cover_photo, :fill, 200, 70) : nil
          end
          row :starts_at_date
          row(:starts_at_time){|m| m.starts_at_time ? m.starts_at_time.strftime('%H:%M') : nil}
          row(:ends_at_time){|m| m.ends_at_time ? m.ends_at_time.strftime('%H:%M') : nil}
        end
      end
      panel 'Address Details' do
        attributes_table_for meeting.address do
          row :id
          row :description
          row :online_meeting_description
          row :street_name
          row :street_number
          row :zip
          row :city
          row :coordinates
        end
      end
    end
    column do
      panel 'TeilnehmerInnen' do
        table_for meeting.going_tos do
          column(:id){|g| g.user.id}
          column(:username){|g| g.user.username}
          column(:role){|g| status_tag(g.role)}
          column(:going_to_date){|g| g.going_to_date}
          column(''){|m| link_to 'User Anzeigen', admin_user_path(m.user) }
        end
      end
      panel 'Additional Dates' do
        table_for meeting.meeting_additional_dates do
          column(:date){|g| link_to g.starts_at_date, admin_meeting_additional_date_path(g)}
        end
      end
      panel 'Aktion Selbstständige für Selbstständige' do
        attributes_table_for meeting do
          row :platform_meeting
          row :meeting_category
        end
        attributes_table_for meeting.platform_meeting_join_request do
          row(:request_message){|p| p.request_message if p}
        end
      end
    end
  end
end
