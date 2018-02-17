class LocationsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    head :ok and return if request.format.html? && browser.bot?
    @locations = collection_scope.approved.include_for_box
    @locations = filter_collections(@locations)
    @locations = @locations.order("last_activity_at DESC").page(params[:page]).per(15)
  end

  def show
    @graetzl = Graetzl.find(params[:graetzl_id])
    @location = @graetzl.locations.find(params[:id])
    redirect_enqueued and return if @location.pending?
    @posts = @location.posts.includes(:images, :comments).order(created_at: :desc).page(params[:page])
    @zuckerls = @location.zuckerls.live
    @room_offer = RoomOffer.where(location_id: @location).last
    @room_demand = RoomDemand.where(location_id: @location).last
  end

  def new
    if request.get?
      @graetzl = Graetzl.find(params[:graetzl_id] || current_user.graetzl_id)
      @district = @graetzl.districts.first
      render :graetzl_form
    else
      @graetzl = Graetzl.find(params[:graetzl_id])
      @location = @graetzl.locations.build
      @location.build_contact
    end
  end

  def create
    @location = Location.new create_location_params
    if @location.save
      redirect_enqueued
    else
      render :new
    end
  end

  def edit
    set_location
  end

  def update
    set_location
    if @location.update location_params
      redirect_to [@location.graetzl, @location]
    else
      render :edit
    end
  end

  def destroy
    set_location
    @location.destroy
    redirect_to locations_user_path, notice: 'Location entfernt'
  end

  private

  def collection_scope
    if params[:graetzl_id].present?
      graetzl = Graetzl.find(params[:graetzl_id])
      Location.where(graetzl: graetzl)
    else
      Location.all
    end
  end

  def filter_collections(locations)
    graetzl_ids = params.dig(:filter, :graetzl_ids)
    if graetzl_ids.present? && graetzl_ids.any?(&:present?)
      locations = locations.where(graetzl_id: graetzl_ids)
    end
    locations
  end

  def set_location
    @location = current_user.locations.find params[:id]
  end

  def paginate_content
    case
    when params[:page]
      @posts = @location.posts.order(created_at: :desc).page(params[:page]).per(10)
    when params[:meetings]
      @meetings = @location.meetings.include_for_box.by_currentness.page(params[:meetings]).per(2)
    end
  end

  def redirect_enqueued
    redirect_to root_url, notice: 'Deine Locationanfrage wird geprüft. Du erhältst eine Nachricht sobald sie bereit ist.'
  end

  def location_params
    params.
      require(:location).
      permit(:name,
        :graetzl_id,
        :slogan,
        :description,
        :avatar, :remove_avatar,
        :cover_photo, :remove_cover_photo,
        :category_id,
        :meeting_permission,
        :product_list,
        contact_attributes: [
          :id,
          :website,
          :email,
          :phone,
          :hours],
        address_attributes: [
          :id,
          :street_name,
          :street_number,
          :zip,
          :city,
          :_destroy])
  end

  def create_location_params
    location_params.merge(user_ids: [current_user.id])
  end
end
