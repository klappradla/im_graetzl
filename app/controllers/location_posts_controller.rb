class LocationPostsController < ApplicationController
  before_action :authenticate_user!, except: [:comments]

  def create
    @location_post = LocationPost.new location_post_params
    if @location_post.save
      @location_post.create_activity :create, owner: current_user
    end
  end

  def comment
    set_location_post
    @comment = @location_post.comments.new comment_params
    if @comment.save
      @location_post.create_activity :comment, owner: current_user, recipient: @comment
    end
  end

  def destroy
    @location_post = LocationPost.find(params[:id]).destroy
  end

  private

  def location_post_params
    params.require(:location_post).permit(
      :graetzl_id,
      :author_id,
      :author_type,
      :title,
      :content,
      images_files: [])
  end

  def comment_params
    params.require(:comment).permit(
      :content,
      images_files: []).merge(user_id: current_user.id)
  end

  def set_location_post
    @location_post = LocationPost.find params[:location_post_id]
  end
end
