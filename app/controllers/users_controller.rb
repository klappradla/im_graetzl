class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @graetzl = Graetzl.find_by_slug(params[:graetzl_id])
    redirect_to([@user.graetzl, @user], status: 301) and return if wrong_graetzl?(@user, @graetzl)
    @wall_comments = @user.wall_comments.includes(:user, :images).order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      bypass_sign_in @user
      redirect_to [@user.graetzl, @user], notice: "Profil gespeichert!"
    else
      render :edit
    end
  end

  def rooms
    @user = current_user
    @rooms = RoomOffer.where(user_id: @user) + RoomDemand.where(user_id: @user)
  end

  def zuckerls
    @zuckerls = Zuckerl.where(location: current_user.locations).
      where.not(aasm_state: :cancelled)
  end

  def locations
    @locations = current_user.locations.includes(:location_ownerships, :graetzl)
  end

  def groups
    @groups = current_user.groups.includes(:room_offer, :room_call)
  end

  private

  def wrong_graetzl?(user, graetzl)
    graetzl.nil? || user.graetzl != graetzl
  end

  def user_params
    params[:user][:role] = nil if !params[:user][:role].present?
    params[:user][:role] = 0 if current_user.admin?
    params[:user].delete(:password) if params[:user][:password].blank?
    params.
      require(:user).
      permit(:email,
        :password,
        :first_name,
        :last_name,
        :website,
        :bio,
        :newsletter,
        :role,
        :avatar, :remove_avatar,
        :cover_photo, :remove_cover_photo)
  end
end
