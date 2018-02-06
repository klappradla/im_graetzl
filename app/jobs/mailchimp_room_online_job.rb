class MailchimpRoomOnlineJob < ApplicationJob

  def perform(room)
    list_id = Rails.application.secrets.mailchimp_list_id

    member_id = mailchimp_member_id(room.user)

    begin
      g = Gibbon::Request.new
      g.timeout = 30
      g.lists(list_id).members(member_id).update(body: {
        merge_fields: {
          ROOM_TITLE: room.slogan,
          ROOM_URL: Rails.application.routes.url_helpers.room_offer_path(room),
          'GROUPINGS' => {0 => {'id' => '9e9d77d5c4', 'groups' => room.district.zip }}
        }
      })
    rescue Gibbon::MailChimpError => mce
      SuckerPunch.logger.error("subscribe failed: due to #{mce.message}")
      raise mce
    rescue => e
      SuckerPunch.logger.error("subscribe failed: due to #{e.message}")
      raise e
    end

  end

  def mailchimp_member_id(user)
    Digest::MD5.hexdigest(user.email.downcase)
  end
end
