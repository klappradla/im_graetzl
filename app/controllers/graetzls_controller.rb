class GraetzlsController < ApplicationController
  before_action :load_graetzl

  def show
    @activity_sample = ActivitySample.new(graetzl: @graetzl) if !user_signed_in?
  end

  def meetings
  end

  def locations
  end

  def rooms
  end

  def zuckerls
  end

  def posts
  end

  def groups
    @featured_groups = @graetzl.groups.featured.include_for_box
    @category = GroupCategory.find_by(id: params[:category])
  end

  private

  def load_graetzl
    @graetzl = Graetzl.find(params[:id])
  end

end
