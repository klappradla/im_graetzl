class Notifications::CommentOnDiscussionPost < Notification
  TRIGGER_KEY = 'discussion_post.comment'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**4

  def self.receivers(activity)
    User.where(id: activity.trackable.user_id)
  end

  def self.description
    "Meine erstellten Inhalte wurden kommentiert"
  end

  def mail_subject
    "#{activity.owner.username} hat deinen Beitrag kommentiert."
  end

  def headline
    group.title
  end

  def discussion_post
    activity.trackable
  end

  def group
    discussion_post.group
  end

  def comment
    activity.trackable.comments.find_by_id(activity.recipient_id)
  end

  def group_discussion_post_id
    activity.trackable.id
  end

end
