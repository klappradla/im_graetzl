class GraetzlsController < ApplicationController

  def show
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
    @activity_sample = ActivitySample.new(graetzl: @graetzl) if !user_signed_in?
  end

  def meetings
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
  end

  def locations
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
  end

  def rooms
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
  end

  def zuckerls
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
  end

  def posts
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
  end

  def groups
    @graetzl = Graetzl.find(params[:id])
    @map_data = MapData.call(graetzl: @graetzl)
    @featured_groups = @graetzl.groups.featured.include_for_box
    @category = GroupCategory.find_by(id: params[:category])
  end

end
