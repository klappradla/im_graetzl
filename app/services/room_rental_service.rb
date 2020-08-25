class RoomRentalService

  def initiate_card_payment(room_rental, payment_params)
    if payment_params[:payment_method_id].blank?
      return { error: "Missing payment method ID." }
    end

    if room_rental.renter.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: room_rental.renter.email)
      room_rental.renter.update(stripe_customer_id: stripe_customer.id)
    end

    if payment_params[:payment_intent_id].blank?
      intent = Stripe::PaymentIntent.create(
        customer: room_rental.renter.stripe_customer_id,
        description: room_rental.room_offer.slogan,
        amount: (room_rental.total_price * 100).to_i,
        currency: 'eur',
        payment_method: payment_params[:payment_method_id],
        capture_method: 'manual',
        confirmation_method: 'manual',
        confirm: true,
      )

      if intent.status == 'requires_action'
        return { requires_action: true, payment_intent_client_secret: intent.client_secret }
      end

      payment_params[:payment_intent_id] = intent.id
    end

    room_rental.update(
      stripe_payment_intent_id: payment_params[:payment_intent_id],
      payment_method: 'card',
      rental_status: :pending,
    )

    return { success: true }
  end

  def approve(room_rental)
    if room_rental.payment_method == 'card'
      Stripe::PaymentIntent.capture(room_rental.stripe_payment_intent_id)
    elsif room_rental.payment_method == 'klarna'
      Stripe::Charge.capture(room_rental.stripe_charge_id)
    end

    invoice_number = "#{Date.current.year}_RR-#{room_rental.id}_Nr-#{RoomRental.next_invoice_number}"
    room_rental.update(rental_status: :approved, payment_status: :payment_success, invoice_number: invoice_number)
    generate_invoices(room_rental)
    RoomMailer.rental_approved(room_rental).deliver_later
  rescue Stripe::InvalidRequestError => e
    room_rental.update(rental_status: :rejected, payment_status: :payment_failed)
  end

  def reject(room_rental)
    if room_rental.payment_method == 'card'
      Stripe::PaymentIntent.cancel(room_rental.stripe_payment_intent_id)
    elsif room_rental.payment_method.in?(['klarna', 'eps'])
      Stripe::Refund.create(charge: room_rental.stripe_charge_id)
    end
    room_rental.rejected!
    RoomMailer.rental_rejected(room_rental).deliver_later
  end

  def cancel(room_rental)
    if room_rental.payment_method == 'card'
      Stripe::PaymentIntent.cancel(room_rental.stripe_payment_intent_id)
    elsif room_rental.payment_method.in?(['klarna', 'eps'])
      Stripe::Refund.create(charge: room_rental.stripe_charge_id)
    end
    room_rental.canceled!
    RoomMailer.rental_canceled(room_rental).deliver_later
  end

  private

  def generate_invoices(room_rental)
    renter_invoice = RoomRentalInvoice.new.generate_for_renter(room_rental)
    room_rental.renter_invoice.put(body: renter_invoice)
    owner_invoice = RoomRentalInvoice.new.generate_for_owner(room_rental)
    room_rental.owner_invoice.put(body: owner_invoice)
  end

end
