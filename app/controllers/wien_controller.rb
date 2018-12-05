class WienController < ApplicationController

  def show
    @districts = District.order(zip: :asc)
    @map_data = MapData.call(districts: @districts)
  end

  def visit_graetzl
    @address = Address.from_feature(params[:feature])
    if @address && @address.graetzls.present?
      redirect_to @address.graetzls.first
    else
      redirect_to wien_url
    end
  end

  def locations
  end

  def meetings
  end

  def rooms
  end

  def groups
    @featured_groups = Group.featured
    @category = GroupCategory.find_by(id: params[:category])
  end

  def zuckerl
  end
end
