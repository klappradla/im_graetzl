class RoomDemandsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :activate]

  def show
    @room_demand = RoomDemand.find(params[:id])
    @comments = @room_demand.comments.includes(:user, :images).order(created_at: :desc)
  end

  def new
    @room_demand = RoomDemand.new
    @room_demand.assign_attributes(current_user.slice(:first_name, :last_name, :email, :website))
  end

  def create
    @room_demand = RoomDemand.new(room_demand_params)
    @room_demand.user_id = current_user.admin? ? params[:user_id] : current_user.id

    if @room_demand.save
      MailchimpRoomDemandUpdateJob.perform_later(@room_demand)
      RoomMailer.room_demand_published(@room_demand).deliver_later
      @room_demand.create_activity(:create, owner: @room_demand.user)
      redirect_to @room_demand
    else
      render 'new'
    end
  end

  def edit
    @room_demand = current_user.room_demands.find(params[:id])
  end

  def update
    @room_demand = current_user.room_demands.find(params[:id])
    if @room_demand.update(room_demand_params)
      MailchimpRoomDemandUpdateJob.perform_later(@room_demand)
      redirect_to @room_demand
    else
      render 'edit'
    end
  end

  def toggle
    @room_demand = current_user.room_demands.find(params[:id])
    @room_demand.enabled? ? @room_demand.disabled! : @room_demand.enabled!
    MailchimpRoomDemandUpdateJob.perform_later(@room_demand)
    flash[:notice] = t("activerecord.attributes.room_demand.status_message.#{@room_demand.status}")
    redirect_back(fallback_location: rooms_user_path)
  end

  def update_status
    @room_demand = current_user.room_demands.find(params[:id])
    @room_demand.update(status: params[:status])
    MailchimpRoomDemandUpdateJob.perform_later(@room_demand)
    flash[:notice] = t("activerecord.attributes.room_demand.status_message.#{@room_demand.status}")
    redirect_back(fallback_location: rooms_user_path)
  end

  def activate
    @room_demand = RoomDemand.find(params[:id])
    if params[:activation_code].to_i == @room_demand.activation_code
      @room_demand.update(last_activated_at: @room_demand.set_last_activated_at)
      @room_demand.update(status: "enabled")
      flash[:notice] = "Dein Raumteiler wurde erfolgreich verlängert!"
    else
      flash[:notice] = "Der Aktivierungslink ist leider ungültig. #{@room_demand.created_at.to_i}"
    end
    redirect_to @room_demand
  end

  def destroy
    @room_demand = current_user.room_demands.find(params[:id])
    @room_demand.destroy

    redirect_to rooms_user_path
  end

  private

  def room_demand_params
    params
      .require(:room_demand)
      .permit(
        :demand_type,
        :slogan,
        :needed_area,
        :demand_description,
        :personal_description,
        :tenant_description,
        :wants_collaboration,
        :avatar,
        :activation_code,
        :remove_avatar,
        :first_name, :last_name, :website, :email, :phone, :location_id,
        room_category_ids: [],
        graetzl_ids: [],
    ).merge(
      keyword_list: [params[:suggested_keywords], params[:custom_keywords]].join(", ")
    )
  end
end
