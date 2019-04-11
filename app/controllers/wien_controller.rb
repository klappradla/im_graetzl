class WienController < ApplicationController

  def show
    @districts = District.order(zip: :asc)
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
    @featured_groups = Group.featured.include_for_box
    @category = GroupCategory.find_by(id: params[:category])
  end

  def zuckerl
  end
end
