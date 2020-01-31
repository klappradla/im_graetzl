class RoomOffersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :activate]

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
      MailchimpRoomOfferUpdateJob.perform_later(@room_offer)
      RoomMailer.room_offer_published(@room_offer).deliver_later
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
      MailchimpRoomOfferUpdateJob.perform_later(@room_offer)
      redirect_to @room_offer
    else
      render 'edit'
    end
  end

  def update_status
    @room_offer = current_user.room_offers.find(params[:id])
    @room_offer.update(status: params[:status])
    MailchimpRoomOfferUpdateJob.perform_later(@room_offer)
    flash[:notice] = t("activerecord.attributes.room_offer.status_message.#{@room_offer.status}")
    redirect_back(fallback_location: rooms_user_path)
  end

  def activate
    @room_offer = RoomOffer.find(params[:id])
    if params[:activation_code].to_i == @room_offer.activation_code
      @room_offer.update(last_activated_at: @room_offer.set_last_activated_at)
      @room_offer.update(status: "enabled")
      flash[:notice] = "Dein Raumteiler wurde erfolgreich verlängert!"
    else
      flash[:notice] = "Der Aktivierungslink ist leider ungültig. #{@room_offer.created_at.to_i}"
    end
    redirect_to @room_offer
  end

  def toggle_waitlist
    @room_offer = RoomOffer.find(params[:id])
    if @room_offer.waiting_users.include?(current_user)
      @room_offer.room_offer_waiting_users.where(user_id: current_user.id).delete_all
      flash[:notice] = 'Du wurdest von der Warteliste entfernt.'
    else
      @room_offer.room_offer_waiting_users.create(user_id: current_user.id)
      RoomMailer.waiting_list_updated(@room_offer, current_user).deliver_later
      flash[:notice] = "Du stehst nun auf der Warteliste und #{@room_offer.first_name} #{@room_offer.last_name} wurde darüber per E-Mail informiert."
    end
    redirect_to @room_offer
  end

  def add_to_wailist
  end

  def remove_from_waitlist
    @room_offer = RoomOffer.find(params[:id])
    user = User.find(params[:user])
    if current_user == user || current_user.id == @room_offer.user_id
      @room_offer.room_offer_waiting_users.where(user_id: user.id).delete_all
      redirect_to @room_offer
      flash[:notice] = "#{user.full_name} wurde von der Warteliste entfernt."
    else
      redirect_to @room_offer
      flash[:notice] = 'Keine Rechte'
    end
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
        :activation_code,
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
