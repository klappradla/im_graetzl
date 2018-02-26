class ReportsController < ApplicationController

  def mailchimp

    list_id = Rails.application.secrets.mailchimp_list_id
    g = Gibbon::Request.new
    g.timeout = 30
    g.lists(list_id).retrieve

    render :json => g

  end

end
