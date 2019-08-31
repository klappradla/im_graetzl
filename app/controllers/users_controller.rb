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

  def tool_offers
    @tool_offers = current_user.tool_offers.non_deleted
    @tool_offer_rentals = current_user.tool_offer_rentals.includes(:tool_offer, :user, :user_message_thread )
    @tool_rentals = current_user.tool_rentals.includes(:user_message_thread, tool_offer: :user)
  end

  def zuckerls
    @zuckerls = Zuckerl.where(location: current_user.locations).
      where.not(aasm_state: :cancelled)
  end

  def locations
    @locations = current_user.locations.includes(:location_ownerships)
  end

  def groups
    @groups = current_user.groups.includes(:room_offer, :room_call, :discussion_categories)
  end

  private

  def wrong_graetzl?(user, graetzl)
    graetzl.nil? || user.graetzl != graetzl
  end

  def user_params
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
        :business,
        :avatar, :remove_avatar,
        :cover_photo, :remove_cover_photo,
        :location_category_id,
        business_interest_ids: [],
    )
  end
end
