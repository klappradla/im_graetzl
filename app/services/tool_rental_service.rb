class ToolRentalService

  def initiate_card_payment(tool_rental, payment_params)
    if payment_params[:payment_method_id].blank?
      return { error: "Missing payment method ID." }
    end

    stripe_customer_id = get_stripe_customer_id(tool_rental.renter)

    if payment_params[:payment_intent_id].blank?
      intent = Stripe::PaymentIntent.create(
        customer: stripe_customer_id,
        amount: (tool_rental.total_price * 100).to_i,
        currency: 'eur',
        description: tool_rental.tool_offer.title,
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

    tool_rental.update(
      stripe_payment_intent_id: payment_params[:payment_intent_id],
      payment_method: 'card',
      payment_card_last4: card.last4,
      rental_status: :pending,
    )

    UserMessageThread.create_for_tool_rental(tool_rental)
    tool_rental.create_activity(:create, owner: tool_rental.renter)
    ToolOfferMailer.new_rental_request(tool_rental).deliver_later
    return { success: true }
  end

  def initiate_eps_payment(tool_rental)
    stripe_customer_id = get_stripe_customer_id(tool_rental.renter)

    intent = Stripe::PaymentIntent.create(
      customer: stripe_customer_id,
      amount: (tool_rental.total_price * 100).to_i,
      currency: 'eur',
      payment_method_types: ['eps'],
      description: tool_rental.tool_offer.title,
    )

    tool_rental.update(
      stripe_payment_intent_id: intent.id,
    )

    return { payment_intent_client_secret: intent.client_secret }
  rescue Stripe::InvalidRequestError => e
    return { error: e.json_body[:error][:message] }
  end

  def confirm_eps_payment(tool_rental, payment_intent)
    if payment_intent.status == 'succeeded'
      tool_rental.update(
        payment_method: 'eps',
        rental_status: :pending,
      )
      UserMessageThread.create_for_tool_rental(tool_rental)
      tool_rental.create_activity(:create, owner: tool_rental.renter)
      ToolOfferMailer.new_rental_request(tool_rental).deliver_later
    end
  end

  def approve(tool_rental)
    case tool_rental.payment_method
    when 'card'
      Stripe::PaymentIntent.capture(tool_rental.stripe_payment_intent_id)
    when 'eps'
      # Doesn't support delayed capture, we already charged the user.
    when 'klarna'
      Stripe::Charge.capture(tool_rental.stripe_charge_id)
    end

    invoice_number = "#{Date.current.year}_ToolRental-#{tool_rental.id}_Nr-#{ToolRental.next_invoice_number}"
    tool_rental.update(
      rental_status: :approved,
      payment_status: :payment_success,
      invoice_number: invoice_number
    )

    generate_invoices(tool_rental)
    tool_rental.create_activity(:approve, owner: tool_rental.owner)
    ToolOfferMailer.rental_approved(tool_rental).deliver_later
  rescue Stripe::InvalidRequestError => e
    tool_rental.update(rental_status: :rejected, payment_status: :payment_failed)
  end

  def reject(tool_rental)
    undo_payment(tool_rental)
    tool_rental.rejected!
    tool_rental.create_activity(:reject, owner: tool_rental.owner)
    ToolOfferMailer.rental_rejected(tool_rental).deliver_later
  end

  def cancel(tool_rental)
    undo_payment(tool_rental)
    tool_rental.canceled!
    tool_rental.create_activity(:cancel, owner: tool_rental.renter)
    ToolOfferMailer.rental_canceled(tool_rental).deliver_later
  end

  def expire(tool_rental)
    undo_payment(tool_rental)
    tool_rental.update(
      rental_status: :expired,
      payment_status: :payment_canceled
    )
  end

  def confirm_return(tool_rental)
    tool_rental.update(rental_status: :return_confirmed)
    tool_rental.create_activity(:return_confirmed, owner: tool_rental.owner)

    ToolOfferMailer.return_confirmed_owner(tool_rental).deliver_later
    ToolOfferMailer.return_confirmed_renter(tool_rental).deliver_later
  end

  private

  def get_stripe_customer_id(user)
    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end
    user.stripe_customer_id
  end

  def generate_invoices(tool_rental)
    renter_invoice = ToolRentalInvoice.new.generate_for_renter(tool_rental)
    tool_rental.renter_invoice.put(body: renter_invoice)
    owner_invoice = ToolRentalInvoice.new.generate_for_owner(tool_rental)
    tool_rental.owner_invoice.put(body: owner_invoice)
  end

  def undo_payment(tool_rental)
    case tool_rental.payment_method
    when 'card'
      Stripe::PaymentIntent.cancel(tool_rental.stripe_payment_intent_id)
    when 'eps'
      Stripe::Refund.create(payment_intent: tool_rental.stripe_payment_intent_id)
    when 'klarna'
      Stripe::Refund.create(charge: tool_rental.stripe_charge_id)
    end
  end

end
