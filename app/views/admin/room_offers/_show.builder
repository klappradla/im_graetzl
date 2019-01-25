context.instance_eval do
  columns do
    column do
      panel 'Room Offer Details' do
        attributes_table_for room_offer do
          row :id
          row :offer_type
          row :slogan
          row :slug
          row :created_at
          row :updated_at
          row :room_description
          row :owner_description
          row :tenant_description
          row :total_area
          row :rented_area
          row :wants_collaboration
          row :keyword_list

          row :room_categories do |g|
            safe_join(
              g.room_categories.map do |category|
                content_tag(:span, link_to(category.name, admin_room_category_path(category)))
              end
            )
          end

          row :cover_photo do |r|
            r.cover_photo ? attachment_image_tag(r, :cover_photo, :fill, 200, 70) : nil
          end
          row :avatar do |r|
            r.avatar ? attachment_image_tag(r, :avatar, :fill, 200, 200) : nil
          end
        end
      end

      panel 'Address Details' do
        attributes_table_for room_offer.address do
          row :id
          row :description
          row :street_name
          row :street_number
          row :zip
          row :city
          row :coordinates
        end
      end

      panel 'Contact Details' do
        attributes_table_for room_offer do
          row :first_name
          row :last_name
          row :website
          row :email
          row :phone
        end
      end
    end

    column do
      panel 'Associations' do
        tabs do
          tab 'User' do
            table_for room_offer.user do
              column(:id){|u| u.id}
              column(:username){|u| u.username}
              column(:role){|u| status_tag(u.role)}
              column(''){|u| link_to 'User Anzeigen', admin_user_path(u) }
            end
          end
          tab 'Location' do
            table_for(room_offer.location || []) do
              column :id
              column :name
              column(:state){|l| status_tag(l.state)}
              column :slug
              column :created_at
              column(''){|l| link_to 'Anzeigen', admin_location_path(l) }
            end
          end
          tab 'Comments' do
            table_for room_offer.comments do
              column(:id){|c| c.id}
              column(:username){|c| c.user.username}
              column(:created_at)
            end
          end

        end
      end
    end
  end
end
