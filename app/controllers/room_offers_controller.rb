class RoomOffersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @room_offer = RoomOffer.find(params[:id])
    @comments = @room_offer.comments.includes(:user, :images).order(created_at: :desc)
  end

  def select
  end

  def new
    @room_offer = RoomOffer.new
    @room_offer.room_offer_prices.build
    @room_offer.assign_attributes(current_user.slice(:first_name, :last_name, :email, :website))
  end

  def create
    @room_offer = RoomOffer.new(room_offer_params)
    @room_offer.user_id = current_user.admin? ? params[:user_id] : current_user.id
    @room_offer.address = Address.from_feature(params[:feature])
    if @room_offer.save
      RoomsMailer.new.send_new_room_offer_email(@room_offer)
      MailchimpRoomOfferOnlineJob.perform_later(@room_offer)
      @room_offer.create_activity(:create, owner: @room_offer.user)
      redirect_to @room_offer
    else
      render 'new'
    end
  end

  def edit
    @room_offer = current_user.room_offers.find(params[:id])
  end

  def update
    @room_offer = current_user.room_offers.find(params[:id])
    if @room_offer.update(room_offer_params)
      MailchimpRoomOfferOnlineJob.perform_later(@room_offer)
      redirect_to @room_offer
    else
      render 'edit'
    end
  end

  def update_status
    @room_offer = current_user.room_offers.find(params[:id])
    @room_offer.update(status: params[:status])
    redirect_to rooms_user_path
  end

  def toggle_waitlist
    @room_offer = RoomOffer.find(params[:id])
    if @room_offer.waiting_users.include?(current_user)
      @room_offer.room_offer_waiting_users.where(user_id: current_user.id).delete_all
      flash[:notice] = 'You have been removed from the waitinglist.'
    else
      @room_offer.room_offer_waiting_users.create(user_id: current_user.id)
      RoomsMailer.new.send_waitinglist_update_email(@room_offer, current_user)
      flash[:notice] = 'You are on the waitinglist now - The owner is informed and as soon as a seat becomes available he will contact you.'
    end
    redirect_to @room_offer
  end

  def destroy
    @room_offer = current_user.room_offers.find(params[:id])
    @room_offer.destroy
    redirect_to rooms_user_path
  end

  private

  def room_offer_params
    params
      .require(:room_offer)
      .permit(
        :offer_type,
        :slogan,
        :rented_area,
        :total_area,
        :room_description,
        :owner_description,
        :tenant_description,
        :wants_collaboration,
        :cover_photo,
        :remove_cover_photo,
        :avatar,
        :remove_avatar,
        :first_name, :last_name, :website, :email, :phone, :location_id,
        images_files: [],
        images_attributes: [:id, :_destroy],
        address_attributes: [
          :id, :street_name, :street_number, :zip, :city
        ],
        room_offer_prices_attributes: [
          :id, :name, :amount, :_destroy
        ],
        room_category_ids: []
    ).merge(
      keyword_list: [params[:suggested_keywords], params[:custom_keywords]].join(", ")
    )
  end
end
