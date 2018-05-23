class MailchimpUnsubscribeJob < ApplicationJob

  def perform(user)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = mailchimp_member_id(user)

    begin
      g = Gibbon::Request.new
      g.timeout = 30
      g.lists(list_id).members(member_id).upsert(body: {
        email_address: user.email, status: "unsubscribed"
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
