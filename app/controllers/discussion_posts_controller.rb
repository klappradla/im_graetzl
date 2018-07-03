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

  def update
    @post = @group.discussion_posts.find(params[:id])
    if @post && @post.edit_permission?(current_user)
      @post.update(discussion_post_params)
      render 'groups/discussion_posts/update'
    else
      head :ok
    end
  end

  def destroy
    @post = @group.discussion_posts.find(params[:id])
    if @post && @post.delete_permission?(current_user)
      @post.destroy
      render 'groups/discussion_posts/destroy'
    else
      head :ok
    end
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
    params.require(:discussion_post).permit(:content)
  end

end
