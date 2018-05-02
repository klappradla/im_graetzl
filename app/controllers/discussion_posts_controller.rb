class DiscussionPostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  
  def create
    @discussion_post = DiscussionPost.new(discussion_post_params)
    @discussion_post.user = current_user
    if @discussion_post.save
      redirect_to @discussion_post.discussion
    end
  end
  
  private
    def discussion_post_params
      params.require(:discussion_post).permit(:discussion_id, :user_id, :content)
    end
end