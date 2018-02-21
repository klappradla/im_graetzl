class ZuckerlsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    head :ok and return if browser.bot? && !request.format.js?
    @zuckerls = collection_scope
    @zuckerls = @zuckerls.page(params[:page]).per(15).order("RANDOM()")
  end

  def new
    set_location_for_new or return
    @zuckerl = @location.zuckerls.new
  end

  def create
    @location = Location.find(params[:location_id])
    @zuckerl = @location.zuckerls.new zuckerl_params
    if @zuckerl.save
      redirect_to zuckerl_billing_address_path @zuckerl
    else
      render :new
    end
  end

  def edit
    set_location
    set_zuckerl_or_redirect
  end

  def update
    set_location
    set_zuckerl_or_redirect or return
    if @zuckerl.update zuckerl_params
      redirect_to zuckerls_user_path, notice: 'Zuckerl wurde aktualisiert'
    else
      render :edit
    end
  end

  def destroy
    set_location
    @location.zuckerls.find(params[:id]).cancel!
    redirect_to zuckerls_user_path, notice: 'Zuckerl wurde gelöscht'
  end

  private

  def collection_scope
    if params[:graetzl_id].present?
      graetzl = Graetzl.find(params[:graetzl_id])
      graetzl.zuckerls
    elsif params[:district_id].present?
      district = District.find(params[:district_id])
      district.zuckerls
    else
      Zuckerl.live
    end
  end

  def set_location_for_new
    case
    when params[:location_id].present?
      @location = Location.find(params[:location_id])
    when current_user.locations.approved.count == 1
      @location = current_user.locations.approved.first
    else
      @locations = current_user.locations.approved
      render :new_location and return
    end
  end

  def set_location
    @location = current_user.locations.find params[:location_id]
  end

  def set_zuckerl_or_redirect
    @zuckerl = @location.zuckerls.where(aasm_state: ['pending', 'paid']).find params[:id]
  rescue ActiveRecord::RecordNotFound
    redirect_to zuckerls_user_path, alert: 'Zuckerl können leider nicht mehr bearbeitet werden wenn sie live sind.' and return
  end

  def zuckerl_params
    params.require(:zuckerl).permit(
      :title,
      :description,
      :image,
      :remove_image,
      :initiative_id,
      :flyer)
  end
end
