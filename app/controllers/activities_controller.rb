class ActivitiesController < ApplicationController

  def index
    head :ok and return if browser.bot? && !request.format.js?
    @graetzl = Graetzl.find(params[:graetzl_id]) if params[:graetzl_id]
    @district = District.find(params[:district_id]) if params[:district_id]
    stream = ActivityStream.new(@graetzl, @district)
    @activity = stream.fetch.page(params[:page]).per(12)
    @activity_with_zuckerls = stream.insert_zuckerls(@activity) if params[:page].blank?
  end

end
