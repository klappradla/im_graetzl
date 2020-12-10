class ActivityStream

  def initialize(graetzl, district)

    district ? @area = district : @area = graetzl

  end

  def fetch
    activities = [
      Activity.where(trackable_id: @area.meetings.non_private.pluck(:id), key: ['meeting.comment', 'meeting.create', 'meeting.go_to', 'meeting.paid_go_to']),
      Activity.where(trackable_id: Meeting.non_private.pluck(:id), cross_platform: true, key: ['meeting.comment', 'meeting.create', 'meeting.go_to', 'meeting.paid_go_to']),
      Activity.where(trackable_id: @area.location_ids, key: ['location.create']),

      Activity.where(trackable_id: @area.location_post_ids, key: ['location_post.comment', 'location_post.create']),
      Activity.where(trackable_id: @area.user_post_ids, key: ['user_post.comment', 'user_post.create']),
      Activity.where(trackable_id: @area.admin_post_ids, key: ['admin_post.comment', 'admin_post.create']),

      #Activity.where(trackable_id: @graetzl.post_ids, key: ['user_post.comment', 'user_post.create']),

      Activity.where(trackable_id: @area.room_offer_ids, key: ['room_offer.create', 'room_offer.update', 'room_offer.comment']),
      Activity.where(trackable_id: @area.room_demand_ids, key: ['room_demand.create', 'room_demand.update']),
      Activity.where(trackable_id: @area.room_call_ids, key: ['room_call.create']),
      Activity.where(trackable_id: @area.tool_offers.enabled.pluck(:id), key: ['tool_offer.create', 'tool_offer.comment']),
      Activity.where(trackable_id: @area.groups.non_private.pluck(:id), key: ['group.create']),
    ].reduce(:or)

    activity_ids = activities.select('DISTINCT ON(trackable_id, trackable_type) id')
    activity_ids = activity_ids.order(:trackable_id, :trackable_type, id: :desc)
    Activity.includes(:owner, :trackable).where(id: activity_ids).order(id: :desc)
  end

  def insert_zuckerls(activity_items)
    zuckerls_sample_size = activity_items.size * 0.2
    zuckerls = @area.zuckerls.limit(zuckerls_sample_size).order(Arel.sql("RANDOM()")).to_a
    zuckerl_items = Array.new(activity_items.size){|i| zuckerls[i] || nil}.shuffle
    activity_items.zip(zuckerl_items).flatten.compact
  end

end
