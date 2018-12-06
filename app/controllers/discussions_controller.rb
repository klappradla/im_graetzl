class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_group

  def index
    @discussions = @group.discussions.order("sticky DESC, last_post_at DESC")
    @discussions = @discussions.includes(discussion_posts: [:user, :images])
    if params[:discussion_category_id].present?
      @discussions = @discussions.where(discussion_category_id: params[:discussion_category_id])
      @category = @group.discussion_categories.find(params[:discussion_category_id])
    end

    render 'groups/discussions/index'
  end

  def show
    @discussion = @group.discussions.find(params[:id])
    @posts = @discussion.discussion_posts.includes(:user, :group).order(created_at: :asc)
    render 'groups/discussions/show'
  end

  def create
    @discussion = @group.discussions.build(discussion_params)
    @discussion.user = current_user
    @discussion.discussion_posts.build(discussion_post_params.merge(user: current_user))
    if @discussion.save
      @discussion.discussion_followings.create(user: current_user)
      @discussion.create_activity(:create, owner: current_user)
      redirect_to [@group, @discussion]
    else
      redirect_to [@group, @discussion]
    end
  end

  def edit
    @discussion = @group.discussions.find(params[:id])
    render 'groups/discussions/edit'
  end

  def update
    @discussion = @group.discussions.find(params[:id])
    redirect_to [@group, @discussion] and return if @discussion.user != current_user
    @discussion.update(discussion_params)
    redirect_to [@group, @discussion]
  end

  def toggle_following
    @discussion = @group.discussions.find(params[:id])
    following = @discussion.discussion_followings.find_by(user: current_user)
    if following
      following.destroy
    else
      @discussion.discussion_followings.create(user: current_user)
    end

    head :ok
  end

  def destroy
    @discussion = @group.discussions.find(params[:id])
    if @discussion && @discussion.delete_permission?(current_user)
      @discussion.destroy
      redirect_to @group
    else
      head :ok
    end
  end

  private

  def check_group
    @group = Group.find(params[:group_id])
    if @group.nil?
      flash[:error] = "Group not found"
      redirect_to root_url
    elsif !@group.readable_by?(current_user)
      flash[:error] = "No access"
      redirect_to @group
    end
  end

  def discussion_params
    params.require(:discussion).permit(:title, :sticky, :closed, :discussion_category_id)
  end

  def discussion_post_params
    params.require(:discussion).require(:initial_post).permit(:content, images_files: [])
  end
end
