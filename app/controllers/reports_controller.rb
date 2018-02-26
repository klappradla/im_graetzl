class ReportsController < ApplicationController

  def mailchimp

    list_id = Rails.application.secrets.mailchimp_list_id
    gibbon = Gibbon::Request.new

    gibbon.lists(list_id).members.retrieve

    respond_to do |format|
      format.json{render :json => gibbon}
    end

    #render :json => gibbon

  end

end
