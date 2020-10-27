class DistrictsController < ApplicationController
  before_action :load_district

  def show
    @activity_sample = ActivitySample.new(district: @district)
  end

  def graetzls
    render json: District.memoized(@district.id).graetzls.to_json(only: [:id, :name])
  end

  def meetings
    @category = EventCategory.find_by(id: params[:category]) if params[:category].present?
    @special_category = params[:special_category] if params[:special_category].present?
  end

  def locations
  end

  def rooms
    @category = RoomCategory.find_by(id: params[:category]) if params[:category].present?
    @special_category = params[:special_category] if params[:special_category].present?
  end

  def tool_offers
    @category = ToolCategory.find_by(id: params[:category]) if params[:category].present?
  end

  def groups
    @featured_groups = @district.groups.featured.include_for_box
    @category = GroupCategory.find_by(id: params[:category])
  end

  def zuckerls
  end

  private

  def load_district
    @district = District.find(params[:id])
  end

end
