class GoingToService

  def initiate_card_payment(user, description, amount, payment_method_id)
    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end

    intent = Stripe::PaymentIntent.create(
      customer: user.stripe_customer_id,
      description: description,
      amount: (amount * 100).to_i,
      currency: 'eur',
      payment_method: payment_method_id,
      capture_method: 'automatic',
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

  def initiate_eps_payment(user, description, amount, eps_info, redirect_url)
    if user.stripe_customer_id.blank?
      stripe_customer = Stripe::Customer.create(email: user.email)
      user.update(stripe_customer_id: stripe_customer.id)
    end

    stripe_source = Stripe::Source.create(
      type: 'eps',
      amount: (amount * 100).to_i,
      currency: 'eur',
      statement_descriptor: description,
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

  def generate_invoice(going_to)
    invoice_number = "#{Date.current.year}_GoingTo-#{going_to.id}_Nr-#{GoingTo.next_invoice_number}"
    going_to.update(invoice_number: invoice_number)
    invoice = GoingToInvoice.new.generate(going_to)
    going_to.invoice.put(body: invoice)
  end

  private

end
