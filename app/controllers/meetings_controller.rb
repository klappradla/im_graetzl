class MeetingsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    head :ok and return if browser.bot? && !request.format.js?
    @meetings = collection_scope.include_for_box
    @meetings = filter_collection(@meetings)
    @meetings = @meetings.visible_to(current_user)
    @meetings = @meetings.by_currentness.page(params[:page]).per(params[:per_page] || 30)
  end

  def show
    @graetzl = Graetzl.find(params[:graetzl_id])
    @meeting = @graetzl.meetings.find(params[:id])
    @comments = @meeting.comments.includes(:user, :images).order(created_at: :desc)
  end

  def new
    @meeting = initialize_meeting
  end

  def create
    @meeting = initialize_meeting
    @meeting.assign_attributes(meeting_params)
    @meeting.graetzl = @meeting.address.try(:graetzl) || @meeting.graetzl
    @meeting.user = current_user
    @meeting.going_tos.new(user_id: current_user.id, role: :initiator)

    if @meeting.save
      if @meeting.online_meeting
        @meeting.create_activity :create_visible_to_all, owner: current_user
      else
        @meeting.create_activity :create, owner: current_user
      end

      redirect_to [@meeting.graetzl, @meeting]
    else
      render :new
    end
  end

  def edit
    @meeting = find_user_meeting
  end

  def update
    @meeting = find_user_meeting
    @meeting.assign_attributes(meeting_params)
    @meeting.graetzl = @meeting.address.graetzl if @meeting.address.try(:graetzl)
    @meeting.state = :active

    #changed_attributes = @meeting.changed_attributes.keys.map(&:to_sym)
    #changed_attributes.push(:address) if @meeting.address.try(:changed?)

    if @meeting.save
      # Prevent Activity for Meeting Changes
      #if (changed_attributes & [:address, :address_attributes, :starts_at_time, :starts_at_date, :ends_at_time, :description]).present?
      #  @meeting.create_activity :update, owner: current_user, parameters: { changed_attributes: changed_attributes }
      #end
      redirect_to [@meeting.graetzl, @meeting]
    else
      render :edit
    end
  end

  def attend
    @meeting = Meeting.find(params[:id])
    if params[:meeting_additional_date_id].present?
      if params[:meeting_additional_date_id] == 'original_date'
        @meeting.going_tos.new(
          user_id: current_user.id,
          going_to_date: @meeting.starts_at_date,
          going_to_time: @meeting.starts_at_time,
        )
      else
        @meeting_additional_date = MeetingAdditionalDate.find(params[:meeting_additional_date_id])
        @meeting.going_tos.new(
          user_id: current_user.id,
          going_to_date: @meeting_additional_date.starts_at_date,
          going_to_time: @meeting_additional_date.starts_at_time,
          meeting_additional_date_id: @meeting_additional_date.id,
        )
      end
    else
      @meeting.going_tos.new(
        user_id: current_user.id,
      )
    end
    @meeting.save
    @meeting.create_activity(:go_to, owner: current_user)
    #flash[:notice] = "Du wurdest als InteressentIn hinzugefügt."
    redirect_to [@meeting.graetzl, @meeting]
  end

  def unattend
    @meeting = Meeting.find(params[:id])
    @meeting.going_tos.find_by(user_id: current_user.id).destroy
    redirect_to [@meeting.graetzl, @meeting]
  end

  def destroy
    @meeting = find_user_meeting
    # Meeting auf Cancelled setzen:
    # Erklärung: call method if method returns true (cancelled wird ausgeführt, dann activity)
    #@meeting.create_activity(:cancel, owner: current_user) if @meeting.cancelled!
    #redirect_to @meeting.graetzl, notice: 'Dein Treffen wurde abgesagt.'

    @meeting.destroy
    redirect_to root_path, notice: 'Dein Treffen wurde gelöscht.'

  end

  private

  def collection_scope
    if params[:location_id].present?
      Meeting.where(location_id: params[:location_id])
    elsif params[:district_id].present?
      district = District.find(params[:district_id])
      Meeting.where(graetzl_id: district.graetzl_ids)
    elsif params[:initiated_user_id].present?
      user = User.find(params[:initiated_user_id])
      user.initiated_meetings
    elsif params[:attended_user_id].present?
      user = User.find(params[:attended_user_id])
      user.attended_meetings
    elsif params[:platform_meeting].present?
      Meeting.where(platform_meeting: params[:platform_meeting])
    else
      Meeting.all
    end
  end

  def filter_collection(meetings)
    graetzl_ids = params.dig(:filter, :graetzl_ids)
    if graetzl_ids.present? && graetzl_ids.any?(&:present?)
      meetings = meetings.where(graetzl_id: graetzl_ids)
    end
    meetings
  end

  def meeting_params
    result =
      params.require(:meeting)
      .permit(
        :graetzl_id,
        :group_id,
        :name,
        :description,
        :starts_at_date,
        :starts_at_time,
        :ends_at_time,
        :cover_photo,
        :remove_cover_photo,
        :location_id,
        :platform_meeting,
        :online_meeting,
        :amount,
        meeting_additional_dates_attributes: [:id, :starts_at_date, :starts_at_time, :ends_at_time, :_destroy],
        address_attributes: [:id, :description, :online_meeting_description, :street_name, :street_number, :zip, :city, :coordinates]
    )

    feature_address = Address.from_feature(params[:feature]) if params[:feature]
    result[:address_attributes].merge!(feature_address.attributes.symbolize_keys.compact) if feature_address
    result
  end

  def going_to_params
    params.permit(
      :meeting_id, :meeting_additional_date_id
    )
  end

  def initialize_meeting
    if params[:location_id].present?
      location = Location.find(params[:location_id])
      location.build_meeting
    elsif params[:graetzl_id].present?
      graetzl = Graetzl.find(params[:graetzl_id])
      graetzl.build_meeting
    elsif params[:group_id].present?
      group = Group.find(params[:group_id])
      group.build_meeting
    else
      graetzl = current_user.graetzl
      graetzl.build_meeting
    end
  end

  def find_user_meeting
    current_user.initiated_meetings.find(params[:id])
  end
end
