class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @group = Group.find(params[:id])
    # TODO: eager load discussion_posts.first.user
    @discussions = @group.discussions.order(created_at: :desc)

    # prepare an empty discussion for the new discussion form
    @discussion = Discussion.new(group: @group)
    @discussion.discussion_posts.build
  end

  def new
    @group = Group.new(room_offer_id: params[:room_offer_id])
  end

  def create
    @group = Group.new(group_params)
    @group.admin_id = current_user.id

    if @group.save
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update(group_params)
      redirect_to @group
    else
      render 'edit'
    end
  end

  def request_join
    @group = Group.find(params[:id])
    @group.group_join_requests.create(user_id: current_user.id)
    redirect_to @group
  end

  def accept_request
    @group = current_user.groups.find(params[:group_id])
    @join_request = @group.group_join_requests.find(params[:id])
    @group.users << @join_request.user
    @join_request.destroy
    redirect_to @group
  end

  def reject_request
    @group = current_user.groups.find(params[:group_id])
    @join_request = @group.group_join_requests.find(params[:id])
    @join_request.update(rejected: true)
    redirect_to @group
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy

    redirect_to home_path
  end

  private

  def check_group_admin
    if current_user != @group.admin
      redirect_to @group
    end
  end

  def group_params
    params
      .require(:group)
      .permit(
        :title,
        :description,
        :room_offer_id,
    )
  end
end
