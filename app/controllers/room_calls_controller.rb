class RoomCallsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @room_call = RoomCall.find(params[:id])
  end

  def new
    @room_call = RoomCall.new
    @room_call.assign_attributes(current_user.slice(:first_name, :last_name, :email, :website))
  end

  def create
    @room_call = RoomCall.new(room_call_params)
    @room_call.user_id = current_user.admin? ? params[:user_id] : current_user.id
    @room_call.address = Address.from_feature(params[:feature]) if params[:feature].present?
    if @room_call.save
      @room_call.create_activity(:create, owner: @room_call.user)
      redirect_to @room_call
    else
      render 'new'
    end
  end

  def edit
    @room_call = current_user.room_calls.find(params[:id])
  end

  def update
    @room_call = current_user.room_calls.find(params[:id])
    if @room_call.update(room_call_params)
      redirect_to @room_call
    else
      render 'edit'
    end
  end

  def submission
    @room_call = RoomCall.find(params[:id])
    if @room_call.group.admins.include?(current_user)
      @room_call_submission = @room_call.room_call_submissions.find(params[:submission_id])
    else
      redirect_to @room_call
    end
  end

  def add_submission
    @room_call = RoomCall.find(params[:id])
    @room_call_submission = @room_call.room_call_submissions.build(room_call_submission_params)
    @room_call_submission.user = current_user
    params[:answers].each do |field_id, content|
      @room_call_submission.room_call_submission_fields.build(room_call_field_id: field_id, content: content)
    end

    if @room_call_submission.save
      RoomCallMailer.notify_submitter(@room_call_submission).deliver_later
      RoomCallMailer.notify_owner(@room_call_submission).deliver_later
      if !@room_call.group.users.include?(current_user)
        @room_call.group.group_join_requests.create(user_id: current_user.id, request_message: "A call submitter wants to join the group.")
      end
      flash[:notice] = "Danke für deine Bewerbung - Wir haben dir soeben ein E-Mail gesendet mit ein paar weiteren Infos .."
      redirect_to @room_call
    else
      flash[:error] = @room_call.errors.full_messages.first
      redirect_to @room_call
    end
  end

  private

  def room_call_params
    params.require(:room_call).permit(
      :title,
      :subtitle,
      :description,
      :starts_at,
      :ends_at,
      :opens_at,
      :about_us,
      :about_partner,
      :slug,
      :total_vacancies,
      :user_id,
      :location_id,
      :first_name,
      :last_name,
      :website,
      :email,
      :phone,
      :avatar, :remove_avatar,
      :cover_photo, :remove_cover_photo,
      room_call_fields_attributes: [:id, :label, :_destroy],
      room_call_prices_attributes: [:id, :name, :description, :features, :amount, :_destroy, room_module_ids: []],
      room_call_modules_attributes: [:id, :room_module_id, :description, :quantity, :_destroy],
      address_attributes: [:id, :_destroy, :street_name, :street_number, :zip, :city, :coordinates, :description],
      images_files: [],
      images_attributes: [:id, :_destroy],
    )
  end

  def room_call_submission_params
    params.permit(:first_name, :last_name, :email, :phone, :website)
  end

end
