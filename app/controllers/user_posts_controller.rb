class UserPostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    set_graetzl
    @post = @graetzl.posts.where(type: 'UserPost').find(params[:id])
    @comments = @post.comments.includes(:user, :images).order(created_at: :desc)
  end

  def new
    set_graetzl
    @user_post = current_user.posts.build graetzl: @graetzl
  end

  def create
    set_graetzl
    @user_post = current_user.posts.new user_post_params
    @user_post.graetzl = @graetzl
    if @user_post.save
      @user_post.create_activity :create, owner: current_user
      redirect_to [@graetzl, @user_post]
    else
      render :new
    end
  end

  def destroy
    @user_post = UserPost.find(params[:id])
    @user_post.destroy
    redirect_to @user_post.graetzl, notice: 'Beitrag gelöscht'
  end

  private

  def set_graetzl
    @graetzl = Graetzl.find(params[:graetzl_id])
  end

  def user_post_params
    params.require(:user_post).permit(
      :title,
      :content,
      images_files: [])
  end
end
