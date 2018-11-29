class MailchimpRoomDemandUpdateJob < ApplicationJob

  def perform(room)
    list_id = Rails.application.secrets.mailchimp_list_id

    member_id = mailchimp_member_id(room.user)

    begin
      g = Gibbon::Request.new
      g.timeout = 30
      g.lists(list_id).members(member_id).update(body: {
        merge_fields: {
          ROOM_TYPE: I18n.t("activerecord.attributes.room_demand.demand_types.#{room.demand_type}"),
          ROOM_STATE: I18n.t("activerecord.attributes.room_demand.statuses.#{room.status}"),
          ROOM_TITLE: room.slogan,
          ROOM_URL: Rails.application.routes.url_helpers.room_demand_path(room),
          ROOM_PLZ: room.districts.map(&:zip).join(", "),
          ROOM_CAT: room.room_categories.map(&:name).join(", "),
          ROOM_ID: room.id,
          ROOM_DATE: room.created_at
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
