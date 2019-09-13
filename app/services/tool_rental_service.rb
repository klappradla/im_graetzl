class ToolRentalService

  def initiate_card_payment(user, tool_offer, amount, payment_method_id)

    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end

    intent = Stripe::PaymentIntent.create(
      customer: user.stripe_customer_id,
      description: tool_offer.title,
      amount: (amount * 100).to_i,
      currency: 'eur',
      payment_method: payment_method_id,
      capture_method: 'manual',
      confirmation_method: 'manual',
      confirm: true,
    )

    if intent.status == 'requires_action'
      return { requires_action: true, payment_intent_client_secret: intent.client_secret }
    elsif intent.status == 'requires_capture'
      return { success: true, payment_intent_id: intent.id }
    elsif intent.status == 'succeeded'
      # Already paid?
      return { success: true, payment_intent_id: intent.id }
    else
      return { error: "Invalid Payment intent" }
    end
  end

  def initiate_klarna_payment(user, tool_offer, amount, klarna_info, redirect_url)
    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end

    stripe_source = Stripe::Source.create(
      type: 'klarna',
      amount: (amount * 100).to_i,
      currency: 'eur',
      owner: {
        email: klarna_info[:email],
        address: {
          line1: klarna_info[:address], postal_code: klarna_info[:zip],
          city: klarna_info[:city], country: 'AT'
        },
      },
      klarna: {
        product: 'payment',
        purchase_country: 'AT',
        first_name: klarna_info[:first_name],
        last_name: klarna_info[:last_name],
      },
      source_order: {
        items: [{
          type: 'sku',
          description: tool_offer.description,
          quantity: 1,
          amount: (amount * 100).to_i,
          currency: 'eur',
        }]
      },
      flow: 'redirect',
      redirect: { return_url: redirect_url },
    )

    Stripe::Customer.create_source(user.stripe_customer_id, source: stripe_source)
    { success: true, redirect_url: stripe_source.redirect.url }
  rescue Stripe::InvalidRequestError => e
    return { success: false, error: e.json_body[:error][:message] }
  end

  def initiate_eps_payment(user, tool_offer, amount, eps_info, redirect_url)
    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end

    stripe_source = Stripe::Source.create(
      type: 'eps',
      amount: (amount * 100).to_i,
      currency: 'eur',
      statement_descriptor: tool_offer.title,
      owner: {
        name: eps_info[:full_name],
      },
      redirect: { return_url: redirect_url },
    )

    Stripe::Customer.create_source(user.stripe_customer_id, source: stripe_source)
    { success: true, redirect_url: stripe_source.redirect.url }
  rescue Stripe::InvalidRequestError => e
    return { success: false, error: e.json_body[:error][:message] }
  end

  def confirm_rental(tool_rental)
    if tool_rental.payment_method.in?(['klarna', 'eps'])
      capture_immediately = tool_rental.payment_method == 'eps' ? true : false
      stripe_charge = Stripe::Charge.create(
        customer: tool_rental.renter.stripe_customer_id,
        amount: (tool_rental.total_price * 100).to_i,
        currency: 'eur',
        source: tool_rental.stripe_source_id,
        capture: capture_immediately,
      )
      tool_rental.update(stripe_charge_id: stripe_charge.id)
    end
  end

  def approve(tool_rental)
    if tool_rental.payment_method == 'card'
      Stripe::PaymentIntent.capture(tool_rental.stripe_payment_intent_id)
    elsif tool_rental.payment_method == 'klarna'
      Stripe::Charge.capture(tool_rental.stripe_charge_id)
    end
    tool_rental.update(rental_status: :approved, payment_status: :payment_success)
    ToolOfferMailer.rental_approved(tool_rental).deliver_later
  rescue Stripe::InvalidRequestError => e
    tool_rental.update(rental_status: :rejected, payment_status: :payment_failed)
  end

  def reject(tool_rental)
    if tool_rental.payment_method == 'card'
      Stripe::PaymentIntent.cancel(tool_rental.stripe_payment_intent_id)
    elsif tool_rental.payment_method.in?(['klarna', 'eps'])
      Stripe::Refund.create(charge: tool_rental.stripe_charge_id)
    end
    tool_rental.rejected!
    ToolOfferMailer.rental_rejected(tool_rental).deliver_later
  end

  def cancel(tool_rental)
    if tool_rental.payment_method == 'card'
      Stripe::PaymentIntent.cancel(tool_rental.stripe_payment_intent_id)
    elsif tool_rental.payment_method.in?(['klarna', 'eps'])
      Stripe::Refund.create(charge: tool_rental.stripe_charge_id)
    end
    tool_rental.canceled!
    ToolOfferMailer.rental_canceled(tool_rental).deliver_later
  end

end
