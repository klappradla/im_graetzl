class ActivitySample

  def initialize(graetzl: nil, district: nil)
    @graetzl = graetzl
    @district = district
  end

  def meetings
    if @graetzl
      @graetzl.meetings.include_for_box.by_currentness.first(2)
    elsif @district
      @district.meetings.include_for_box.by_currentness.first(2)
    else
      Meeting.include_for_box.by_currentness.first(2)
    end
  end

  def locations
    if @graetzl
      @graetzl.locations.approved.include_for_box.order("last_activity_at DESC").first(2)
    elsif @district
      @district.locations.approved.include_for_box.order("last_activity_at DESC").first(2)
    else
      Location.approved.include_for_box.order("last_activity_at DESC").first(2)
    end
  end

  def rooms
    room_call = RoomCall.open_calls.first
    if @graetzl
      room_offer = @graetzl.room_offers.enabled.by_currentness.first
      room_demand = @graetzl.room_demands.enabled.by_currentness.first
    elsif @district
      room_offer = @district.room_offers.enabled.by_currentness.first
      room_demand = @district.room_demands.enabled.by_currentness.first
    else
      room_offer = RoomOffer.enabled.by_currentness.first
      room_demand = RoomDemand.enabled.by_currentness.first
    end
    [room_call, room_offer, room_demand].compact.first(2)
  end

  def zuckerls
    if @graetzl
      @graetzl.zuckerls.include_for_box.order("RANDOM()").first(2)
    elsif @district
      @district.zuckerls.include_for_box.order("RANDOM()").first(2)
    else
      Zuckerl.live.include_for_box.order("RANDOM()").first(2)
    end
  end

  def posts
    if @graetzl
      @graetzl.posts.where(type: "UserPost").order(created_at: :desc).first(2)
    end
  end

end
