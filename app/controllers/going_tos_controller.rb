class GoingTosController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  def new
    read_params
    render 'login' and return if !user_signed_in?
  end

  def choose_payment
    read_params
    if params[:source].present?
      @source_status = Stripe::Source.retrieve(params[:source]).status
    end
  end

  def initiate_card_payment
    read_params
    description = "#{@meeting.name}, am #{@display_starts_at_date}"

    result = GoingToService.new.initiate_card_payment(
      current_user, description, @meeting.amount, params[:payment_method_id]
    )

    if result[:error].present?
      render json: { error: result[:error] }, status: :bad_request
    else
      render json: result
    end
  end

  def initiate_eps_payment
    read_params
    description = "#{@meeting.name}, am #{@display_starts_at_date}"

    result = GoingToService.new.initiate_eps_payment(
      current_user, description, @meeting.amount, eps_params, params[:redirect_url]
    )

    if result[:error].present?
      render json: { error: result[:error] }, status: :bad_request
    else
      render json: result
    end

  end

  def create
    read_params

    if current_user.billing_address
      current_user.billing_address.assign_attributes(billing_address_params)
      current_user.billing_address.save!
    else
      billing_address = current_user.create_billing_address(billing_address_params)
      billing_address.save!
    end

    going_to = current_user.going_tos.new(going_to_params)
    going_to.assign_attributes(
      role: :paid_attendee,
      going_to_date: @starts_at_date,
      going_to_time: @starts_at_time,
      amount: @meeting.amount,
      payment_status: :payment_pending,
    )
    if going_to.payment_method.in?(['card'])
      going_to.assign_attributes(payment_status: :payment_success)
    end

    going_to.save!

    @meeting.create_activity :paid_go_to, owner: current_user, cross_platform: @meeting.online_meeting?

    if going_to.payment_method.in?(['card'])
      GoingToService.new.generate_invoice(going_to)
      GoingToMailer.send_invoice(going_to).deliver_later
      AdminMailer.new_paid_going_to(going_to).deliver_later
    end

    if going_to.payment_method.in?(['eps'])
      ChargeGoingToJob.set(wait: 2.minutes).perform_later(going_to)
    end
    #@going_to = going_to
    #render 'summary'
    #render action: :summary
    redirect_to summary_going_tos_url(meeting_id: @meeting.id, going_to_id: going_to.id)

  end

  def summary
    @meeting = Meeting.find(params[:meeting_id])
    @going_to = GoingTo.find(params[:going_to_id])
    @starts_at_date = @going_to.going_to_date
    @starts_at_time = @going_to.going_to_time
    @display_starts_at_date = @going_to.display_starts_at_date
  end

  private

  def billing_address_params
    params.permit(
      :company, :full_name, :street, :zip, :city
    )
  end

  def going_to_params
    params.permit(
      :meeting_id, :meeting_additional_date_id,
      :stripe_payment_intent_id, :stripe_source_id, :payment_method,
    )
  end

  def eps_params
    params.permit(:full_name)
  end

  def read_params
    @meeting = Meeting.find(params[:meeting_id])
    if params[:meeting_additional_date_id].present?
      @meeting_additional_date = MeetingAdditionalDate.find(params[:meeting_additional_date_id])
      @starts_at_date = @meeting_additional_date.starts_at_date
      @starts_at_time = @meeting_additional_date.starts_at_time
      @display_starts_at_date = @meeting_additional_date.display_starts_at_date
    else
      @starts_at_date = @meeting.starts_at_date
      @starts_at_time = @meeting.starts_at_time
      @display_starts_at_date = @meeting.display_starts_at_date
    end
  end

end
