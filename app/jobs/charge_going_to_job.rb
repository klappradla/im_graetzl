class ChargeGoingToJob < ApplicationJob

  def perform(going_to)

    stripe_charge = Stripe::Charge.create(
      customer: going_to.user.stripe_customer_id,
      amount: (going_to.amount * 100).to_i,
      currency: 'eur',
      source: going_to.stripe_source_id,
      capture: true,
    )

    if stripe_charge.status == 'succeeded'
        going_to.assign_attributes(
          stripe_charge_id: stripe_charge.id,
          payment_status: :payment_success,
        )
        going_to.save!
        GoingToService.new.generate_invoice(going_to)
        GoingToMailer.send_invoice(going_to).deliver_later
        AdminMailer.new_paid_going_to(going_to).deliver_later
    elsif stripe_charge.status == 'failed'
        going_to.assign_attributes(
          stripe_charge_id: stripe_charge.id,
          payment_status: :payment_failed,
        )
        going_to.save!
    end

  end
end
