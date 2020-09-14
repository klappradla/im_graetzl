class ToolRentalsController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    @tool_rental = ToolRental.new(initial_rental_params)
    @tool_rental.assign_attributes(current_user_address_params)
    @tool_rental.calculate_price
    render 'login' and return if !user_signed_in?
  end

  def create
    @tool_rental = current_user.tool_rentals.build(tool_rental_params)
    @tool_rental.calculate_price
    @tool_rental.save!
    @tool_rental.create_activity(:create, owner: current_user)

    if current_user.billing_address.nil?
      current_user.create_billing_address(@tool_rental.renter_billing_address)
    end

    redirect_to [:choose_payment, @tool_rental]
  end

  def edit
    @tool_rental = current_user.tool_rentals.find(params[:id])
    if !@tool_rental.incomplete?
      redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id) and return
    end
  end

  def update
    @tool_rental = current_user.tool_rentals.incomplete.find(params[:id])
    @tool_rental.assign_attributes(tool_rental_params)
    @tool_rental.calculate_price
    @tool_rental.save!
    redirect_to [:choose_payment, @tool_rental]
  end

  def choose_payment
    @tool_rental = current_user.tool_rentals.find(params[:id])
    if !@tool_rental.incomplete?
      redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id) and return
    end
  end

  def summary
    @tool_rental = current_user.tool_rentals.find(params[:id])
  end

  def initiate_card_payment
    @tool_rental = current_user.tool_rentals.incomplete.find(params[:id])
    result = ToolRentalService.new.initiate_card_payment(@tool_rental, card_params)
    render json: result, status: result[:error].present? ? :bad_request : :ok
  end

  def initiate_eps_payment
    @tool_rental = current_user.tool_rentals.incomplete.find(params[:id])
    result = ToolRentalService.new.initiate_eps_payment(@tool_rental)
    render json: result, status: result[:error].present? ? :bad_request : :ok
  end

  def complete_eps_payment
    @tool_rental = current_user.tool_rentals.find(params[:id])
    if params[:redirect_status] == 'succeeded'
      redirect_to [:summary, @tool_rental]
    else
      flash[:error] = "EPS Überweisung gescheitert."
      redirect_to [:choose_payment, @tool_rental]
    end
  end

  def cancel
    @tool_rental = current_user.tool_rentals.pending.find(params[:id])
    @tool_rental.create_activity(:cancel, owner: current_user)
    ToolRentalService.new.cancel(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def approve
    @tool_rental = current_user.owned_tool_rentals.pending.find(params[:id])
    @tool_rental.create_activity(:approve, owner: current_user)
    ToolRentalService.new.approve(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def reject
    @tool_rental = current_user.owned_tool_rentals.pending.find(params[:id])
    @tool_rental.create_activity(:reject, owner: current_user)
    ToolRentalService.new.reject(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def confirm_return
    @tool_rental = current_user.owned_tool_rentals.return_pending.find(params[:id])
    @tool_rental.create_activity(:return_confirmed, owner: current_user)
    ToolRentalService.new.confirm_return(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def leave_rating
    @tool_rental = ToolRental.find(params[:id])

    if @tool_rental.owner == current_user
      @tool_rental.update(renter_rating: params[:rating])
      @tool_rental.renter.recalculate_rating
    elsif @tool_rental.renter == current_user
      @tool_rental.update(owner_rating: params[:rating])
      @tool_rental.owner.recalculate_rating
    end

    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  private

  def initial_rental_params
    params.permit(:tool_offer_id, :rent_from, :rent_to)
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

  def tool_rental_params
    params.require(:tool_rental).permit(
      :tool_offer_id,
      :rent_from, :rent_to,
      :renter_name, :renter_address, :renter_zip, :renter_city,
    )
  end

  def card_params
    params.permit(:payment_method_id, :payment_intent_id)
  end

  def eps_params
    params.permit(:payment_intent)
  end

end
