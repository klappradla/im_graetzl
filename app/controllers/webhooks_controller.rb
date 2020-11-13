class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    head :bad_request and return if params[:type].blank? || params[:id].blank?

    event = Stripe::Event.retrieve(params[:id])
    case event.type
    when "payment_intent.succeeded"
      payment_intent_succeded(event.data.object)
    end

    head :ok
  end

  private

  def payment_intent_succeded(payment_intent)
    room_rental = RoomRental.find_by(stripe_payment_intent_id: payment_intent.id)
    if room_rental && payment_intent.payment_method_types.include?('eps')
      RoomRentalService.new.confirm_eps_payment(room_rental, payment_intent)
      return
    end

    tool_rental = ToolRental.find_by(stripe_payment_intent_id: payment_intent.id)
    if tool_rental && payment_intent.payment_method_types.include?('eps')
      ToolRentalService.new.confirm_eps_payment(tool_rental, payment_intent)
      return
    end
  end

end
