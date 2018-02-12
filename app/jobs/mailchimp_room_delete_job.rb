class MailchimpRoomDeleteJob < ApplicationJob

  def perform(user)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = mailchimp_member_id(user)

    begin
      g = Gibbon::Request.new
      g.timeout = 30
      g.lists(list_id).members(member_id).update(body: {
        merge_fields: {
          ROOM_TYPE: nil,
          ROOM_TITLE: nil,
          ROOM_URL: nil,
          ROOM_PLZ: nil,
          ROOM_CAT: nil,
          ROOM_ID: nil,
          ROOM_DATE: nil
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
