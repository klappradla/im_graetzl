class Notifications::NewGroupPost < Notification
  TRIGGER_KEY = 'discussion_post.create'
  DEFAULT_INTERVAL = :daily
  BITMASK = 2**18

  def self.receivers(activity)
    activity.trackable.discussion.following_users
  end

  def self.description
    'Es gibt neue Antworten in Themen denen ich folge'
  end

  def custom_mail_vars
    {
      group_name: group.title,
      discussion_title: activity.trackable.discussion.title,
      discussion_url: group_discussion_url(group, activity.trackable.discussion),
      post_content: activity.trackable.content.truncate(300, separator: ' '),
      post_url: group_discussion_url(group, activity.trackable.discussion, :target => "discussion-post-#{activity.trackable.id}"),
      owner_firstname: activity.owner.first_name,
      owner_avatar_url: Notifications::ImageService.new.avatar_url(activity.trackable.user),
    }
  end

  def mail_subject
    "Neue Antwort von #{activity.owner.first_name} im Thema #{activity.trackable.discussion.title}."
  end

  def group
    activity.trackable.group
  end

  def group_discussion_id
    activity.trackable.discussion_id
  end

end
