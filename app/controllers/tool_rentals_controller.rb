class ToolRentalsController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])

    render 'login' and return if !user_signed_in?
  end

  def choose_payment
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])
    if params[:source].present?
      @source_status = Stripe::Source.retrieve(params[:source]).status
    end
  end

  def summary
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])
    if params[:stripe_payment_intent_id].present?
      intent = Stripe::PaymentIntent.retrieve(params[:stripe_payment_intent_id])
      @card = intent.charges.data.first.payment_method_details.card
    end
  end

  def initiate_card_payment
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])

    result = ToolRentalService.new.initiate_card_payment(
      current_user, @tool_offer, @calculator.total, params[:payment_method_id]
    )

    if result[:error].present?
      render json: { error: result[:error] }, status: :bad_request
    else
      render json: result
    end
  end

  def initiate_klarna_payment
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])

    result = ToolRentalService.new.initiate_klarna_payment(
      current_user, @tool_offer, @calculator.total, klarna_params, params[:redirect_url]
    )

    if result[:error].present?
      render json: { error: result[:error] }, status: :bad_request
    else
      render json: result
    end
  end

  def initiate_eps_payment
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])

    result = ToolRentalService.new.initiate_eps_payment(
      current_user, @tool_offer, @calculator.total, eps_params, params[:redirect_url]
    )

    if result[:error].present?
      render json: { error: result[:error] }, status: :bad_request
    else
      render json: result
    end
  end

  def create
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:rent_from], params[:rent_to])

    @tool_rental = current_user.tool_rentals.build(tool_rental_params)
    @tool_rental.assign_attributes(
      basic_price: @calculator.basic_price,
      discount: @calculator.discount,
      service_fee: @calculator.service_fee,
      insurance_fee: @calculator.insurance_fee,
      tax: @calculator.tax,
    )
    @tool_rental.save!

    ToolRentalService.new.confirm_rental(@tool_rental)

    thread = UserMessageThread.create_for_tool_rental(@tool_rental)
    ToolOfferMailer.new_rental_request(@tool_rental).deliver_later

    redirect_to messenger_url(thread_id: thread.id)
  end

  def cancel
    @tool_rental = current_user.tool_rentals.pending.find(params[:id])
    ToolRentalService.new.cancel(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def approve
    @tool_rental = current_user.owned_tool_rentals.pending.find(params[:id])
    ToolRentalService.new.approve(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def reject
    @tool_rental = current_user.owned_tool_rentals.pending.find(params[:id])
    ToolRentalService.new.reject(@tool_rental)
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def confirm_return
    @tool_rental = current_user.owned_tool_rentals.return_pending.find(params[:id])
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

  def tool_rental_params
    params.permit(
      :tool_offer_id, :rent_from, :rent_to,
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
