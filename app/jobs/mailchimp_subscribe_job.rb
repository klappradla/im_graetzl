class MailchimpSubscribeJob < ApplicationJob

  def perform(user)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = mailchimp_member_id(user)

    begin
      g = Gibbon::Request.new
      g.timeout = 30
      g.lists(list_id).members(member_id).upsert(body: {
        email_address: user.email, status: "subscribed",
        merge_fields: {
          USERID: user.id,
          FNAME: user.first_name,
          LNAME: user.last_name,
          USERROLE: user.role || (user.business? ? 'business' : ''),
          GRAETZL: user.graetzl.name,
          GR_URL: Rails.application.routes.url_helpers.graetzl_path(user.graetzl),
          PLZ: user.graetzl.districts.first.try(:zip),
          USERNAME: user.username,
          PROFIL_URL: Rails.application.routes.url_helpers.user_path(user),
          NEWSLETTER: user.newsletter.to_s,
          SIGNUP: user.created_at,
          ORIGIN: user.origin,
          L_CATEGORY: user.location_category.try(:name)
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
