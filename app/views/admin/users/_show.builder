context.instance_eval do
  columns do
    column do
      panel 'User Details' do
        attributes_table_for user do
          row :id
          row :slug
          row :graetzl
          row :username
          row :first_name
          row :last_name
          row :email
          row :business
          row(:newsletter){|u| status_tag(u.newsletter)}
          row(:role){|u| status_tag(u.role)}
          row :location_category
          row :business_interests do |g|
            safe_join(
              g.business_interests.map do |interest|
                content_tag(:li, link_to(interest.title, admin_business_interest_path(interest)))
              end
            )
          end

          row :bio
          row :website
          row :cover_photo do |u|
            u.cover_photo ? attachment_image_tag(u, :cover_photo, :fill, 200, 70) : nil
          end
          row :avatar do |u|
            u.avatar ? attachment_image_tag(u, :avatar, :fill, 200, 200) : nil
          end
          row :created_at
          row :confirmed_at
          row :updated_at
          row :last_sign_in_at
        end
      end
      if user.address
        panel 'Address Details' do
          attributes_table_for user.address do
            row :id
            row :description
            row(:street){|a| a.street }
            row(:place){|a| "#{a.zip}, #{a.city}"}
            row :coordinates
          end
        end
      end
      if user.curator
        panel 'Grätzlbotschafter' do
          attributes_table_for user.curator do
            row :id
            row :graetzl
            row :created_at
          end
        end
      end
    end
    column do
      panel 'Locations' do
        table_for user.locations do
          column :id
          column :name
          column(:state){|l| status_tag(l.state)}
          column(''){|l| link_to 'Anzeigen', admin_location_path(l) }
        end
      end
      panel 'Raumteiler | Habe Raum' do
        table_for user.room_offers do
          column :id
          column :slogan
          column(:comment_count) {|r| r.comments.size }
          column(''){|l| link_to 'Anzeigen', admin_room_offer_path(l) }
        end
      end

      panel 'Raumteiler | Suche Raum' do
        table_for user.room_demands do
          column :id
          column :slogan
          column(:comment_count) {|r| r.comments.size }
          column(''){|l| link_to 'Anzeigen', admin_room_demand_path(l) }
        end
      end

      panel 'Gruppen Mitglied' do
        table_for user.groups do
          column :id
          column :title
          column(''){|l| link_to 'Anzeigen', admin_group_path(l) }
        end
      end

      panel 'Associations' do
        tabs do
          tab 'Treffen' do
            table_for user.attended_meetings do
              column :id
              column :name
              column :user
              column :created_at
              column(''){|m| link_to 'Anzeigen', admin_meeting_path(m) }
            end
          end
          tab 'Posts' do
            table_for user.posts do
              column :id
              column(:content){|p| truncate(p.content, length: 20)}
              column :graetzl
              column :created_at
              column(''){|p| link_to 'Anzeigen', admin_post_path(p) }
            end
          end
          tab 'Pinnwand' do
            table_for user.wall_comments do
              column :id
              column :user
              column :created_at
            end
          end
        end
      end
    end
  end
end
