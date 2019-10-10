module ActivitiesHelper

  def appendix_path_for(parent)
    case parent.class.to_s
    when LocationPost.to_s
      location = parent.author
      [Graetzl.memoized(location.graetzl_id), location, anchor: dom_id(parent)]
    when AdminPost.to_s
      parent
    when RoomOffer.to_s, RoomDemand.to_s
      [parent, anchor: 'comments-block']
    when ToolOffer.to_s
      [parent, anchor: 'comments-block']
    else
      [parent.graetzl, parent]
    end
  end
end
