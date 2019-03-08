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

  def custom_mail_vars
    {
      group_name: group.title,
      discussion_title: activity.trackable.discussion.title,
      discussion_url: group_discussion_url(group, activity.trackable.discussion),
      comment_content: activity.trackable.comments.find_by_id(activity.recipient_id).content.truncate(300, separator: ' '),
      comment_url: group_discussion_url(group, activity.trackable.discussion, anchor: "discussion-post-#{activity.trackable.id}"),
      post_url: group_discussion_url(group, activity.trackable.discussion, anchor: "discussion-post-#{activity.trackable.id}"),
      owner_firstname: activity.owner.first_name,
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.owner),
    }
  end

  def mail_subject
    "#{activity.owner.username} hat deinen Beitrag kommentiert."
  end

  def group
    activity.trackable.group
  end

  def group_discussion_id
    activity.trackable.discussion_id
  end

end
