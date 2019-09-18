class Notifications::AlsoCommentedDiscussionPost < Notification
  TRIGGER_KEY = 'discussion_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**6

  def self.receivers(activity)
    User.where(id: activity.trackable.comments.includes(:user).pluck(:user_id) - [activity.owner_id])
  end

  def self.description
    'Es gibt neue Antworten auf Inhalte die ich auch kommentiert habe'
  end

  def mail_subject
    "#{activity.owner.username} hat einen Beitrag ebenfalls kommentiert."
  end

  def headline
    group.title
  end

  def group
    activity.trackable.group
  end

  def discussion_post
    activity.trackable
  end

  def comment
    activity.trackable.comments.find_by_id(activity.recipient_id)
  end

  def group_discussion_post_id
    activity.trackable.id
  end

end
