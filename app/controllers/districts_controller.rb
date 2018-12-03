class DistrictsController < ApplicationController

  def show
    @district = District.find(params[:id])
    @map_data = MapData.call district: @district, graetzls: @district.graetzls
    @activity_sample = ActivitySample.new(district: @district)
  end

  def graetzls
    @district = District.find(params[:id])
    render json: @district.graetzls.to_json(only: [:id, :name])
  end

  def meetings
    @district = District.find(params[:id])
    @map_data = MapData.call district: @district, graetzls: @district.graetzls
  end

  def locations
    @district = District.find(params[:id])
    @map_data = MapData.call district: @district, graetzls: @district.graetzls
  end

  def rooms
    @district = District.find(params[:id])
    @map_data = MapData.call district: @district, graetzls: @district.graetzls
  end

  def groups
    @district = District.find(params[:id])
    @map_data = MapData.call district: @district, graetzls: @district.graetzls
    @featured_groups = @district.groups.featured
  end

  def zuckerls
    @district = District.find(params[:id])
    @map_data = MapData.call district: @district, graetzls: @district.graetzls
  end

end
