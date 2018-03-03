class ReportsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
  end

  def mailchimp

    @gibbon = Gibbon::Request.new
    list_id = Rails.application.secrets.mailchimp_list_id

    count = params[:count]

    if (params[:email])

      user_email = params[:email]
      member_id = Digest::MD5.hexdigest(user_email)
      user_activity = params[:activity]
      if (user_activity == 'activity')
        begin
          useractivity = @gibbon.lists(list_id).members(member_id).activity.retrieve
          render json: useractivity
        rescue Gibbon::MailChimpError => e
          render json: e.status_code
        end
      else
        begin
          user = @gibbon.lists(list_id).members(member_id).retrieve
          render json: user
        rescue Gibbon::MailChimpError => e
          render json: e.status_code
        end
      end

    elsif (params[:type] == 'automations')

      automations = @gibbon.automations.retrieve
      render json: automations

    else
      members = @gibbon.lists(list_id).members.retrieve(params: {"count": count})
      render json: members
    end

  end

end
