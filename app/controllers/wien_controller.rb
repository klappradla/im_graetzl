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
    @districts = District.order(zip: :asc)
  end

  def meetings
    @districts = District.order(zip: :asc)
  end

  def rooms
    @districts = District.order(zip: :asc)
  end

  def groups
    @featured_groups = Group.featured.include_for_box
    @category = GroupCategory.find_by(id: params[:category])
    @districts = District.order(zip: :asc)
  end

  def tool_offers
    @districts = District.order(zip: :asc)
  end

  def zuckerls
    @districts = District.order(zip: :asc)
  end

  def platform_meetings
    
  end
end
