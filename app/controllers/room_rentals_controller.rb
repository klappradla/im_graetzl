class RoomRentalsController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    @room_rental = RoomRental.new(initial_rental_params)
    @room_rental.calculate_price
    render 'login' and return if !user_signed_in?
  end

  def calculate_price
    @room_rental = RoomRental.new(calculate_price_params)
    @room_rental.calculate_price
  end

  def address
    if params[:id].present?
      @room_rental = current_user.room_rentals.incomplete.find(params[:id])
      @room_rental.update(room_rental_params)
    else
      @room_rental = RoomRental.new(current_user_address_params)
      @room_rental.assign_attributes(room_rental_params)
    end
    @room_rental.calculate_price
  end

  def create
    @room_rental = current_user.room_rentals.build(room_rental_params)
    @room_rental.calculate_price
    @room_rental.save!
    if current_user.billing_address.nil?
      current_user.create_billing_address(@room_rental.renter_billing_address)
    end
    redirect_to [:choose_payment, @room_rental]
  end

  def edit
    @room_rental = current_user.room_rentals.find(params[:id])
    if !@room_rental.incomplete?
      redirect_to messenger_url(thread_id: @room_rental.user_message_thread.id) and return
    end
  end

  def update
    @room_rental = current_user.room_rentals.incomplete.find(params[:id])
    @room_rental.assign_attributes(room_rental_params)
    @room_rental.calculate_price
    @room_rental.save!
    redirect_to [:choose_payment, @room_rental]
  end

  def choose_payment
    @room_rental = current_user.room_rentals.find(params[:id])
    if !@room_rental.incomplete?
      redirect_to messenger_url(thread_id: @room_rental.user_message_thread.id) and return
    end
  end

  def initiate_card_payment
    @room_rental = current_user.room_rentals.incomplete.find(params[:id])
    result = RoomRentalService.new.initiate_card_payment(@room_rental, card_params)
    render json: result, status: result[:error].present? ? :bad_request : :ok
  end

  def initiate_eps_payment
    @room_rental = current_user.room_rentals.incomplete.find(params[:id])
    result = RoomRentalService.new.initiate_eps_payment(@room_rental)
    render json: result, status: result[:error].present? ? :bad_request : :ok
  end

  def complete_eps_payment
    @room_rental = current_user.room_rentals.find(params[:id])
    if params[:redirect_status] == 'succeeded'
      redirect_to [:summary, @room_rental]
    else
      flash[:error] = "EPS Überweisung gescheitert."
      redirect_to [:choose_payment, @room_rental]
    end
  end

  def summary
    @room_rental = current_user.room_rentals.find(params[:id])
  end

  def cancel
    @room_rental = current_user.room_rentals.pending.find(params[:id])
    RoomRentalService.new.cancel(@room_rental)
    redirect_to messenger_url(thread_id: @room_rental.user_message_thread.id)
  end

  def approve
    @room_rental = current_user.owned_room_rentals.pending.find(params[:id])
    RoomRentalService.new.approve(@room_rental)
    redirect_to messenger_url(thread_id: @room_rental.user_message_thread.id)
  end

  def reject
    @room_rental = current_user.owned_room_rentals.pending.find(params[:id])
    RoomRentalService.new.reject(@room_rental)
    redirect_to messenger_url(thread_id: @room_rental.user_message_thread.id)
  end

  def leave_rating
    @room_rental = RoomRental.find(params[:id])

    if @room_rental.owner == current_user
      @room_rental.update(renter_rating: params[:rating])
      @room_rental.renter.recalculate_rating
    elsif @room_rental.renter == current_user
      @room_rental.update(owner_rating: params[:rating])
      @room_rental.owner.recalculate_rating
    end

    redirect_to messenger_url(thread_id: @room_rental.user_message_thread.id)
  end

  private

  def initial_rental_params
    params.permit(:room_offer_id).merge(
      room_rental_slots_attributes: [params.permit(:rent_date, :hour_from, :hour_to)],
    )
  end

  def current_user_address_params
    {
      renter_name: current_user.billing_address&.full_name || current_user.full_name,
      renter_company: current_user.billing_address&.company,
      renter_address: current_user.billing_address&.street || current_user.address&.street,
      renter_zip: current_user.billing_address&.zip || current_user.address&.zip,
      renter_city: current_user.billing_address&.city || current_user.address&.city,
    }
  end

  def calculate_price_params
    params.require(:room_rental).permit(
      :room_offer_id,
      room_rental_slots_attributes: [:rent_date, :hour_from, :hour_to, :_destroy],
    )
  end

  def room_rental_params
    params.require(:room_rental).permit(
      :room_offer_id,
      :renter_name, :renter_address, :renter_zip, :renter_city,
      room_rental_slots_attributes: [:id, :rent_date, :hour_from, :hour_to, :_destroy],
    )
  end

  def card_params
    params.permit(:payment_method_id, :payment_intent_id)
  end

  def eps_params
    params.permit(:payment_intent)
  end

end
