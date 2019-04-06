class DistrictsController < ApplicationController
  before_action :load_district

  def show
    @activity_sample = ActivitySample.new(district: @district)
  end

  def graetzls
    render json: District.memoized(@district.id).graetzls.to_json(only: [:id, :name])
  end

  def meetings
  end

  def locations
  end

  def rooms
  end

  def groups
    @featured_groups = @district.groups.include_for_box
    @category = GroupCategory.find_by(id: params[:category])
  end

  def zuckerls
  end

  private

  def load_district
    @district = District.find(params[:id])
  end

end
