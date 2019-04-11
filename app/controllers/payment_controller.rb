class PaymentController < ApplicationController
  before_action :authenticate_user!, except: [ :raumteiler, :raumteiler_create, :processing ]

  rescue_from Stripe::CardError, with: :catch_stripe_card_error
  rescue_from Stripe::InvalidRequestError, with: :catch_stripe_invalid_request
  rescue_from Stripe::StripeError, with: :catch_stripe_error

  def raumteiler
    render :template => '/payment/form/raumteiler'
  end

  def charge
    render :template => '/payment/form/charge'
  end

  def subscription
    render :template => '/payment/form/subscription'
  end

  def mentoring
    render :template => '/payment/form/mentoring'
  end

  def processing
    # Build Form Action via Return URL Params from Payment
    stripeForm = payment_params[:stripeForm] # Which Form Action
    stripeParams = request.fullpath.split("?")[1] # Include Params to Form Action
    @stripeFormAction = "#{stripeForm}?#{stripeParams}"
    render :template => '/payment/processing'
  end

  def raumteiler_create
    StripeChargesServices.new(payment_params, current_user).init_invoice
    amount = payment_params[:amount].to_i
    description = payment_params[:stripeDescription]
    @payment_confirmation_info = "#{amount},00 € - Deine #{description}"
    @email = payment_params[:stripeEmail]
    MailchimpPaymentJob.perform_later(@email, '5f02f45ea9') # Insert Mailchimp List ID
    render :template => '/payment/confirmation'
  end

  def charge_create
    StripeChargesServices.new(payment_params, current_user).init_charge
    amount = payment_params[:amount].to_i
    description = payment_params[:stripeDescription]
    @payment_confirmation_info = "#{amount},00 € - #{description}"
    @email = payment_params[:stripeEmail]
    render :template => '/payment/confirmation'
  end

  def subscription_create
    StripeChargesServices.new(payment_params, current_user).init_subscription
    description = payment_params[:stripeDescription]
    @payment_confirmation_info = "#{description}"
    @email = payment_params[:stripeEmail]
    render :template => '/payment/confirmation'
  end

  def mentoring_create
    StripeChargesServices.new(payment_params, current_user).init_invoice
    amount = payment_params[:amount].to_i
    description = payment_params[:stripeDescription]
    @payment_confirmation_info = "#{amount},00 € - #{description}"
    @email = payment_params[:stripeEmail]
    render :template => '/payment/confirmation'
  end

  private

  def payment_params
    params.permit(
      :amount,
      :payment_method,
      :stripeForm,
      :stripeToken,
      :stripeSource,
      :source,
      :stripeName,
      :stripeEmail,
      :stripeDescription,
      :stripePlan,
      :stripeBillingCycleAnchor,
      :stripeTrialEnd,
      :stripeCancelAtPeriodEnd,
      :stripebillingAddress,
      :message,
      :stripeCompany,
      :stripeAddressName,
      :stripeAddress,
      :stripePostalCode,
      :stripeCity
    )
  end

  def catch_stripe_card_error(e)
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end

  def catch_stripe_invalid_request(e)
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end

  def catch_stripe_error(e)
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end
end
