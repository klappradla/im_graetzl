class RoomRentalService

  def initiate_card_payment(room_rental, payment_params)
    if payment_params[:payment_method_id].blank?
      return { error: "Missing payment method ID." }
    end

    stripe_customer_id = get_stripe_customer_id(room_rental.renter)

    if payment_params[:payment_intent_id].blank?
      intent = Stripe::PaymentIntent.create(
        customer: stripe_customer_id,
        amount: (room_rental.total_price * 100).to_i,
        currency: 'eur',
        description: room_rental.room_offer.slogan,
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

    card = Stripe::PaymentIntent.retrieve(
      id: payment_params[:payment_intent_id], expand: ['payment_method']
    ).payment_method.card

    room_rental.update(
      stripe_payment_intent_id: payment_params[:payment_intent_id],
      payment_method: 'card',
      payment_card_last4: card.last4,
      rental_status: :pending,
    )

    room_rental.create_activity(:create, owner: room_rental.renter)
    RoomMailer.new_rental_request(room_rental).deliver_later
    return { success: true }
  end

  def initiate_eps_payment(room_rental)
    stripe_customer_id = get_stripe_customer_id(room_rental.renter)

    intent = Stripe::PaymentIntent.create(
      customer: stripe_customer_id,
      amount: (room_rental.total_price * 100).to_i,
      currency: 'eur',
      payment_method_types: ['eps'],
      description: room_rental.room_offer.slogan,
    )

    room_rental.update(
      stripe_payment_intent_id: intent.id,
    )

    return { payment_intent_client_secret: intent.client_secret }
  rescue Stripe::InvalidRequestError => e
    return { error: e.json_body[:error][:message] }
  end

  def confirm_eps_payment(room_rental, payment_intent)
    if payment_intent.status == 'succeeded'
      room_rental.update(
        payment_method: 'eps',
        rental_status: :pending,
      )
      room_rental.create_activity(:create, owner: room_rental.renter)
      RoomMailer.new_rental_request(room_rental).deliver_later
    end
  end

  def approve(room_rental)
    case room_rental.payment_method
    when 'card'
      Stripe::PaymentIntent.capture(room_rental.stripe_payment_intent_id)
    when 'eps'
      # Doesn't support delayed capture, we already charged the user.
    when 'klarna'
      Stripe::Charge.capture(room_rental.stripe_charge_id)
    end

    invoice_number = "#{Date.current.year}_RR-#{room_rental.id}_Nr-#{RoomRental.next_invoice_number}"
    room_rental.update(
      rental_status: :approved,
      payment_status: :payment_success,
      invoice_number: invoice_number
    )

    generate_invoices(room_rental)
    room_rental.create_activity(:approve, owner: room_rental.owner)
    RoomMailer.rental_approved_renter(room_rental).deliver_later
    RoomMailer.rental_approved_owner(room_rental).deliver_later
  rescue Stripe::InvalidRequestError
    room_rental.update(rental_status: :rejected, payment_status: :payment_failed)
  end

  def reject(room_rental)
    undo_payment(room_rental)
    room_rental.rejected!
    room_rental.create_activity(:reject, owner: room_rental.owner)
    RoomMailer.rental_rejected(room_rental).deliver_later
  end

  def cancel(room_rental)
    undo_payment(room_rental)
    room_rental.canceled!
    room_rental.create_activity(:cancel, owner: room_rental.renter)
    RoomMailer.rental_canceled(room_rental).deliver_later
  end

  def expire(room_rental)
    undo_payment(room_rental)
    room_rental.update(
      rental_status: :expired,
      payment_status: :payment_canceled
    )
  end

  private

  def get_stripe_customer_id(user)
    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end
    user.stripe_customer_id
  end

  def generate_invoices(room_rental)
    renter_invoice = RoomRentalInvoice.new.generate_for_renter(room_rental)
    room_rental.renter_invoice.put(body: renter_invoice)
    owner_invoice = RoomRentalInvoice.new.generate_for_owner(room_rental)
    room_rental.owner_invoice.put(body: owner_invoice)
  end

  def undo_payment(room_rental)
    case room_rental.payment_method
    when 'card'
      Stripe::PaymentIntent.cancel(room_rental.stripe_payment_intent_id)
    when 'eps'
      Stripe::Refund.create(payment_intent: room_rental.stripe_payment_intent_id)
    when 'klarna'
      Stripe::Refund.create(charge: room_rental.stripe_charge_id)
    end
  end
end
