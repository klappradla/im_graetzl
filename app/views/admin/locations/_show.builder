context.instance_eval do
  columns do
    column do
      panel 'Basic Details' do
        attributes_table_for location do
          row :id
          row :name
          row :category
          row :products do |l|
            l.products.each do |p|
              a p.name, href: admin_tag_path(p)
              text_node ', '.html_safe
            end
          end
          row(:state){|l| status_tag(l.state)}
          row :slug
          row :created_at
          row :updated_at
          row :graetzl
          row :slogan
          row :description
          row(:meeting_permission){|l| status_tag(l.meeting_permission)}
          row :cover_photo do |l|
            l.cover_photo ? attachment_image_tag(l, :cover_photo, :fill, 200, 70) : nil
          end
          row :avatar do |l|
            l.avatar ? attachment_image_tag(l, :avatar, :fill, 200, 200) : nil
          end
        end
      end
      panel 'Contact Details' do
        attributes_table_for location.contact do
          row :id
          row :website
          row :email
          row :phone
          row :hours
        end
      end
      if location.address
        panel 'Address Details' do
          attributes_table_for location.address do
            row :id
            row :description
            row(:street){|a| a.street}
            row(:place){|a| "#{a.zip}, #{a.city}"}
            row :coordinates
          end
        end
      end
      if location.billing_address
        panel 'Billing Address Details' do
          attributes_table_for location.billing_address do
            row :id
            row :first_name
            row :last_name
            row :company
            row :street
            row :zip
            row :city
            row :country
          end
        end
      end
    end
    column do
      panel 'Associations' do
        tabs do
          tab 'User' do
            table_for location.location_ownerships do
              column(:id){|o| o.user.id}
              column(:username){|o| o.user.username}
              column(:state){|o| status_tag(o.state)}
              column(''){|o| link_to 'User Anzeigen', admin_user_path(o.user) }
            end
          end
          tab 'Posts' do
            table_for location.posts do
              column :id
              column(:title){|p| truncate(p.title, length: 20)}
              column :slug
              column :created_at
              column(''){|p| link_to 'Anzeigen', admin_post_path(p) }
            end
          end
          tab 'Treffen' do
            table_for location.meetings do
              column :id
              column :name
              column :created_at
              column(''){|m| link_to 'Anzeigen', admin_meeting_path(m) }
            end
          end
          tab 'Zuckerl' do
            table_for location.zuckerls do
              column :id
              column :title
              column(:aasm_state){|z| status_tag(z.aasm_state)}
              column(''){|z| link_to 'Anzeigen', admin_zuckerl_path(z) }
            end
          end
        end
      end
    end
  end
end
