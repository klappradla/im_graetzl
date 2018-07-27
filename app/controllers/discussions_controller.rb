class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_group

  def index
    @discussions = @group.discussions.order("sticky DESC, last_post_at DESC")
    @discussions = @discussions.includes(discussion_posts: :user)
    if params[:group_category_id].present?
      @discussions = @discussions.where(group_category_id: params[:group_category_id])
      @category = @group.group_categories.find(params[:group_category_id])
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
    @discussion.discussion_posts.build(content: params[:content], user: current_user)
    @discussion.save
    redirect_to [@group, @discussion]
  end

  def edit
    @discussion = @group.discussions.find(params[:id])
  end

  def update
    @discussion = @group.discussions.find(params[:id])
    redirect_to [@group, @discussion] and return if @discussion.user != current_user
    @discussion.update(discussion_params)
    redirect_to [@group, @discussion]
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
    params.require(:discussion).permit(:title, :sticky, :closed, :group_category_id)
  end
end
