class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  
  def show
    @discussion = Discussion.find(params[:id])
    @discussion_posts = @discussion.discussion_posts.order(created_at: :asc)
    @discussion_post = DiscussionPost.new(discussion: @discussion)
  end
  
  def create
    @discussion = Discussion.new(discussion_params)
    @discussion.discussion_posts.first.user = current_user
    if @discussion.save
      redirect_to @discussion
    end
  end
  
  private
    def discussion_params
      params.require(:discussion).permit(:group_id, discussion_posts_attributes: [:id, :content])
    end
end