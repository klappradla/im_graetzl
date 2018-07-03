class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :check_group

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

  def update
    @discussion = @group.discussions.find(params[:id])
    redirect_to [@group, @discussion] if @discussion.user != current_user
    @discussion.update(discussion_params)
    redirect_to [@group, @discussion]
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
    params.require(:discussion).permit(:title, :sticky, :closed)
  end
end
