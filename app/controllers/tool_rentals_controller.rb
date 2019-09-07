class ToolRentalsController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:date_from], params[:date_to])

    render 'login' and return if !user_signed_in?

    @tool_rental = @tool_offer.tool_rentals.build(
      user: current_user,
      rent_from: @calculator.date_from,
      rent_to: @calculator.date_to,
    )
  end

  def create_intent
    @tool_offer = ToolOffer.enabled.find(params[:tool_offer_id])
    @calculator = ToolPriceCalculator.new(@tool_offer, params[:date_from], params[:date_to])
    intent = Stripe::PaymentIntent.create(
      amount: (@calculator.total * 100).to_i,
      currency: 'eur',
      payment_method: params[:payment_method_id],
      capture_method: 'manual',
      confirmation_method: 'manual',
      confirm: true,
    )

    if intent.status == 'requires_action'
      render json: { requires_action: true, payment_intent_client_secret: intent.client_secret }
    elsif intent.status == 'requires_capture'
      render json: { success: true, payment_intent_id: intent.id }
    elsif intent.status == 'succeeded'
      # Already paid?
      render json: { success: true, payment_intent_id: intent.id }
    else
      render json: { error: "Invalid Payment intent" }, status: :bad_request
    end
  end

  def create
    @tool_rental = current_user.tool_rentals.build(tool_rental_params)
    calculator = ToolPriceCalculator.new(@tool_rental.tool_offer, @tool_rental.rent_from, @tool_rental.rent_to)
    @tool_rental.assign_attributes(
      basic_price: calculator.basic_price,
      discount: calculator.discount,
      service_fee: calculator.service_fee,
      insurance_fee: calculator.insurance_fee,
    )
    @tool_rental.save!
    thread = UserMessageThread.create_for_tool_rental(@tool_rental)
    ToolOfferMailer.new_rental_request(@tool_rental).deliver_later
    redirect_to messenger_url(thread_id: thread.id)
  end

  def cancel
    @tool_rental = current_user.tool_rentals.pending.find(params[:id])
    Stripe::PaymentIntent.cancel(@tool_rental.stripe_payment_intent_id)
    @tool_rental.canceled!
    ToolOfferMailer.rental_canceled(@tool_rental).deliver_later
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def approve
    @tool_rental = current_user.tool_offer_rentals.pending.find(params[:id])
    intent = Stripe::PaymentIntent.capture(@tool_rental.stripe_payment_intent_id)
    @tool_rental.approved!
    ToolOfferMailer.rental_approved(@tool_rental).deliver_later
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  def reject
    @tool_rental = current_user.tool_offer_rentals.pending.find(params[:id])
    Stripe::PaymentIntent.cancel(@tool_rental.stripe_payment_intent_id)
    @tool_rental.rejected!
    ToolOfferMailer.rental_rejected(@tool_rental).deliver_later
    redirect_to messenger_url(thread_id: @tool_rental.user_message_thread.id)
  end

  private

  def tool_rental_params
    params.require(:tool_rental).permit(
      :tool_offer_id, :rent_from, :rent_to,
      :renter_name, :renter_address, :renter_zip, :renter_city,
      :stripe_payment_intent_id, :payment_method,
    )
  end
end
