class RoomsController < ApplicationController

  def index
    head :ok and return if browser.bot? && !request.format.js?

    room_calls = room_calls_scope.includes(:user, :graetzl, :district)
    room_calls = filter_calls(room_calls)

    room_offers = room_offers_scope.includes(:user, :graetzl, :district)
    room_offers = filter_offers(room_offers)
    room_offers = room_offers.by_currentness.page(params[:page]).per(5)

    room_demands = room_demands_scope.includes(:user, :graetzls, :districts, :room_categories)
    room_demands = filter_demands(room_demands)
    room_demands = room_demands.by_currentness.page(params[:page]).per(5)

    @rooms = []
    @rooms += room_calls.sort_by(&:ends_at).reverse if params[:page].blank?
    @rooms += (room_offers + room_demands).sort_by(&:created_at).reverse
    @next_page = room_offers.next_page.present? || room_demands.next_page.present?
  end

  private

  def room_offers_scope
    if params[:district_id].present?
      RoomOffer.where(district_id: params[:district_id])
    else
      RoomOffer.all
    end
  end

  def room_demands_scope
    if params[:district_id].present?
      district = District.find(params[:district_id])
      RoomDemand.joins(:room_demand_graetzls).where(room_demand_graetzls: {graetzl_id: district.graetzl_ids}).distinct
    else
      RoomDemand.all
    end
  end

  def room_calls_scope
    RoomCall.all
  end

  def filter_offers(offers)
    room_type = params.dig(:filter, :room_type)
    if room_type.present?
      if room_type == 'with_group'
        offers = offers.where(id: Group.distinct.pluck(:room_offer_id).compact)
      elsif room_type != 'offer'
        return RoomOffer.none
      end
    end

    if params.dig(:filter, :show_occupied).present?
      offers = offers.where(status: [:enabled, :occupied])
    else
      offers = offers.enabled
    end

    room_category_ids = params.dig(:filter, :room_category_ids)&.select(&:present?)
    if room_category_ids.present?
      offers = offers.joins(:room_offer_categories).where(room_offer_categories: {room_category_id: room_category_ids}).distinct
    end

    graetzl_ids = params.dig(:filter, :graetzl_ids)
    if graetzl_ids.present? && graetzl_ids.any?(&:present?)
      offers = offers.where(graetzl_id: graetzl_ids)
    end

    offers
  end

  def filter_demands(demands)
    room_type = params.dig(:filter, :room_type)
    if room_type.present? && room_type != 'demand'
      return RoomDemand.none
    end

    demands = demands.enabled

    room_category_ids = params.dig(:filter, :room_category_ids)&.select(&:present?)
    if room_category_ids.present?
      demands = demands.joins(:room_demand_categories).where(room_demand_categories: {room_category_id: room_category_ids}).distinct
    end

    graetzl_ids = params.dig(:filter, :graetzl_ids)&.select(&:present?)
    if graetzl_ids.present?
      demands = demands.joins(:room_demand_graetzls).where(room_demand_graetzls: {graetzl_id: graetzl_ids}).distinct
    end

    demands
  end

  def filter_calls(calls)
    room_type = params.dig(:filter, :room_type)
    if room_type.present?
      if room_type == 'with_group'
        calls = calls.where(id: Group.distinct.pluck(:room_call_id).compact)
      elsif room_type != 'call'
        return RoomCall.none
      end
    end

    calls = calls.open_calls

    calls
  end

end
