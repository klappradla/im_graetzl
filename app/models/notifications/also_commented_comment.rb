class Notifications::AlsoCommentedComment < Notification
  TRIGGER_KEY = 'comment.comment'
  DEFAULT_INTERVAL = :immediate
  BITMASK = 2**22

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    "Ein Beitrag den ich kommentiert habe wurde auch kommentiert"
  end

  def mail_template
    "also_commented"
  end

  def mail_subject
    "#{activity.owner.username} hat einen Beitrag ebenfalls kommentiert."
  end

  def headline
    'Neuer Kommentar bei einem Beitrag'
  end

  def comment
    activity.trackable.comments.find_by_id(activity.recipient_id)
  end

  def content_type
    Comment.where(id: activity.trackable.id).last.commentable_type
  end

  def content_id
    Comment.where(id: activity.trackable.id).last.commentable_id
  end

  def parent_content
    klass = content_type.constantize
    klass.where(id: content_id).last
  end

  def content_title
    case content_type
    when 'Meeting'
      "Treffen: #{parent_content.name}"
    when 'Location'
      "Location: #{parent_content.name}"
    when 'RoomOffer', 'RoomDemand'
      "Raumteiler: #{parent_content.slogan}"
    when 'User'
      "#{parent_content.username}'s Pinnwand"
    when 'ToolOffer'
      "Toolteiler: #{parent_content.title}"
    else
      parent_content.title
    end
  end

  def content_url_params
    case content_type
    when 'Meeting', 'Location', 'User'
      [parent_content.graetzl, parent_content]
    else
      parent_content
    end
  end

  def comment_content_preview
    activity.recipient.content.truncate(300, separator: ' ')
  end

  def comment_url_params
    content_url_params
  end


end
