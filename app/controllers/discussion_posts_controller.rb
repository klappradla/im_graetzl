class DiscussionPostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :comments]
  before_action :check_group

  def create
    @discussion = @group.discussions.find(params[:discussion_id])
    redirect_to [@group, @discussion] and return if @discussion.nil? || @discussion.closed?

    @post = @discussion.discussion_posts.new(discussion_post_params)
    @post.user = current_user
    if @post.save
      @discussion.discussion_followings.find_or_create_by(user: current_user)
      @post.create_activity(:create, owner: current_user)
      redirect_to [@group, @discussion, anchor: "discussion-post-#{@post.id}" ]
    else
      redirect_to [@group, @discussion]
    end
  end

  def comment
    @post = @group.discussion_posts.find(params[:discussion_post_id])
    @comment = @post.comments.new comment_params
    #@comment.save
    if @comment.save
      @post.create_activity :comment, owner: current_user, recipient: @comment
    end
    respond_to do |format|
      format.js { render :file => "groups/discussion_posts/comment.js.erb" }
    end
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
    params.require(:discussion_post).permit(
      :content,
      images_files: [],
      images_attributes: [:id, :_destroy],
    )
  end

  def comment_params
    params.require(:comment).permit(
      :content,
      images_files: []).merge(user_id: current_user.id)
  end

end
