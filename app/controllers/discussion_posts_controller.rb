class DiscussionPostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :check_group

  def create
    @discussion = @group.discussions.find(params[:discussion_id])
    redirect_to [@group, @discussion] and return if @discussion.nil? || @discussion.closed?

    @post = @discussion.discussion_posts.new(discussion_post_params)
    @post.user = current_user
    @post.save
    @discussion.update(last_post_at: @post.created_at)
    redirect_to [@group, @discussion]
  end

  private

  def check_group
    @group = Group.find(params[:group_id])
    if @group.nil?
      redirect_to root_url
    elsif !@group.readable_by?(current_user)
      redirect_to [@group, @discussion]
    end
  end

  def discussion_post_params
    params.require(:discussion_post).permit(:discussion_id, :content)
  end

end
