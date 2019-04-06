class MailchimpPaymentJob < ApplicationJob

  def perform(email, mailchimp_list_id)
    list_id = Rails.application.secrets.mailchimp_list_id
    member_id = mailchimp_member_id(email)

    begin
      g = Gibbon::Request.new
      g.timeout = 30
      g.lists(list_id).members(member_id).update(body: {
        interests: {mailchimp_list_id => true}
      })
    rescue Gibbon::MailChimpError => mce
      SuckerPunch.logger.error("subscribe failed: due to #{mce.message}")
      raise mce
    rescue => e
      SuckerPunch.logger.error("subscribe failed: due to #{e.message}")
      raise e
    end

  end

  def mailchimp_member_id(email)
    Digest::MD5.hexdigest(email.downcase)
  end

end
