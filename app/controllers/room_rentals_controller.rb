class RoomRentalsController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
    render 'login' and return if !user_signed_in?
  end

  def address
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
  end

  def choose_payment
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
  end

  def summary
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
  end

  def initiate_card_payment
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
  end

  def initiate_klarna_payment
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
  end

  def initiate_eps_payment
    @room_offer = RoomOffer.enabled.find(params[:room_offer_id])
  end

  private

  def room_rental_params
    params.permit(
      :room_offer_id,
      :renter_name, :renter_address, :renter_zip, :renter_city,
      :stripe_payment_intent_id, :stripe_source_id, :payment_method,
    )
  end

  def klarna_params
    params.permit(:first_name, :last_name, :email, :address, :zip, :city)
  end

  def eps_params
    params.permit(:full_name)
  end

end
