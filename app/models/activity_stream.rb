class ActivityStream
  STREAM_ACTIVITY_KEYS = [
    'meeting.comment', 'meeting.create', 'meeting.go_to',
    'user_post.comment', 'user_post.create',
    'admin_post.comment', 'admin_post.create',
    'location.create', 'location_post.comment', 'location_post.create',
    'room_offer.create', 'room_offer.comment',
    'room_demand.create', 'room_demand.comment'
  ]

  def initialize(graetzl)
    @graetzl = graetzl
  end

  def fetch
    activity_ids = Activity.where(key: STREAM_ACTIVITY_KEYS).
      select('DISTINCT ON(trackable_id, trackable_type) id').
      where("(trackable_id IN (?) AND trackable_type = 'Meeting') OR
             (trackable_id IN (?) AND trackable_type = 'Location') OR
             (trackable_id IN (?) AND trackable_type LIKE '%Post') OR
             (trackable_id IN (?) AND trackable_type = 'Post') OR
             (trackable_id IN (?) AND trackable_type = 'RoomOffer') OR
             (trackable_id IN (?) AND trackable_type = 'RoomDemand')",
             @graetzl.meeting_ids, @graetzl.location_ids, @graetzl.post_ids, @graetzl.admin_post_ids,
             @graetzl.room_offer_ids, @graetzl.room_demand_ids
      ).order(:trackable_id, :trackable_type, id: :desc)

    Activity.includes(:owner, :trackable).where(id: activity_ids).order(id: :desc)
  end

  def insert_zuckerls(activity_items)
    zuckerls_sample_size = activity_items.size * 0.2
    zuckerls = @graetzl.zuckerls.limit(zuckerls_sample_size).order("RANDOM()").to_a
    zuckerl_items = Array.new(activity_items.size){|i| zuckerls[i] || nil}.shuffle
    activity_items.zip(zuckerl_items).flatten.compact
  end

end
