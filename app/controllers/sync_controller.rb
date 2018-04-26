class SyncController < ApplicationController

  def room

    if Rails.env.production?

      list_id = Rails.application.secrets.mailchimp_list_id
      # Find User of Room
      user = User.find(params[:user_id])
      member_id = mailchimp_member_id(user)

      begin
        g = Gibbon::Request.new
        g.timeout = 30

        # Get Merge Fields from Room Owner
        member_info = g.lists(list_id).members(member_id).retrieve(params: {"fields": "merge_fields"})

        # Find Merge Field ROOM_CLICK and get actual Count-Value
        click_count = member_info.body["merge_fields"]["ROOM_CLICK"]
        click_count = 0 if click_count.blank?

        # Count +1 because its just clicked by a User
        click_count += 1

        # Update Click Count in Mailchimp
        g.lists(list_id).members(member_id).update(body: {
          merge_fields: {
            ROOM_CLICK: click_count
          }
        })

        # Response to Website ...
        render json: click_count

      rescue Gibbon::MailChimpError => e
        render json: e
      end

    end

  end

  def mailchimp_member_id(user)
    Digest::MD5.hexdigest(user.email.downcase)
  end

end
