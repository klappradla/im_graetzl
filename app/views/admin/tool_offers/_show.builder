context.instance_eval do
  columns do
    column do
      panel 'Tool Offer Details' do
        attributes_table_for tool_offer do
          row :id
          row :title
          row(:state){|l| status_tag(l.status)}
          row :description
          row :slug
          row :created_at
          row :updated_at
          row :brand
          row :model
          row :value_up_to
          row :serial_number
          row :known_defects
          row :price_per_day
          row :two_day_discount
          row :weekly_discount
          row :keyword_list

          row :cover_photo do |r|
            r.cover_photo ? attachment_image_tag(r, :cover_photo, :fill, 200, 70) : nil
          end
        end
      end

      panel 'Address Details' do
        attributes_table_for tool_offer.address do
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
        attributes_table_for tool_offer do
          row :first_name
          row :last_name
          row :iban
        end
      end
    end

    column do
      panel 'Associations' do
        tabs do
          tab 'User' do
            table_for tool_offer.user do
              column(:id){|u| u.id}
              column(:username){|u| u.username}
              column(:role){|u| status_tag(u.role)}
              column(''){|u| link_to 'User Anzeigen', admin_user_path(u) }
            end
          end
          tab 'Location' do
            table_for(tool_offer.location || []) do
              column :id
              column :name
              column(:state){|l| status_tag(l.state)}
              column :slug
              column :created_at
              column(''){|l| link_to 'Anzeigen', admin_location_path(l) }
            end
          end
          tab 'Comments' do
            table_for tool_offer.comments do
              column(:id){|c| c.id}
              column(:username){|c| c.user.username}
              column(:created_at)
            end
          end

        end
      end

      panel 'Rent Requests' do
        table_for tool_offer.tool_rentals do
          column :id
          column(:RentUser){|r| r.user}
          column(:rental_status){|r| status_tag(r.rental_status)}
          column(''){|l| link_to 'Anzeigen', admin_tool_rental_path(l) }
        end
      end

    end
  end
end
